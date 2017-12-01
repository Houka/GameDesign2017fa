package gameObjects;

import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.ui.FlxBar; 
import flixel.system.FlxSound;
import openfl.Assets;
using StringTools;

import utils.*;

class Enemy extends FlxSprite{
	public var attackPt:Int;
	public var attackRange:Int = 64; 
	public var healthPt:Float;
	private var type:Int;
	private var speed:Int;
	private var _prevFacing:Int;
	private var _framerate:Int = 8;

	// path variables
	private var _savedPath:Array<FlxPoint>;
	private var _savedSpeed:Float;
	private var _savedOnComplete:FlxPath->Void;

	// attacking vars
	public var isAttacking:Bool = false; 
	private var _targetTower:Tower;
	private var _attackInterval:Int = 1;
	private var _attackCounter:Int = 0;
	private var _tween:Array<FlxTween>;

	public var _healthBar:FlxBar; 
	
	public function init(X:Int, Y:Int, Type:Int, Attack:Int, Health:Int, Speed:Int,Path:Array<FlxPoint>){
		setPosition(X,Y);
		type = Type;
		attackPt = Attack;
		healthPt = Health;
		speed = Speed;
		alpha = 1;
		_healthBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 30, 4, this, "healthPt", 0, this.healthPt,true);
		_healthBar.trackParent(15, 65);
		FlxG.state.add(_healthBar);
		
		isAttacking = false; 
		_attackCounter = 0;
		_tween = [];
		// reset path vars
		_savedPath = null;
		_savedSpeed = 0;
		_savedOnComplete = null;
		angle = 0;

		_prevFacing = facing;
		x=X;
		y=Y;

		followPath(Path, X, Y);
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		if (!alive)
			return;
		// what to do during attacking state
		if (isAttacking){
			_attackCounter += Std.int(FlxG.timeScale);

			if (_attackCounter > (_attackInterval * FlxG.updateFramerate) +  Std.random(10)){
				Sounds.play("enemy_hit");
				_targetTower.hurt(attackPt);
				_attackCounter = 0;

				// move enemy towards tower and then back
				if (_targetTower!=null)
					animateAttack();
			}

		 	// stop attacking a dead tower and go back to path
			if (_targetTower!=null && (!_targetTower.alive || !_targetTower.created)){
				// resume path
				resumePath();

				// stop attacking
		 		isAttacking = false;
		 		_targetTower = null;
		 		_attackCounter = 0;
	 		}
		}

		// update animations based on where we are facing if we changed facing directions
		calculateFacing();

		if(_prevFacing != facing){
			switch (facing){
				case FlxObject.DOWN:
					this.animation.play("walk_down");
				case FlxObject.UP:
					this.animation.play("walk_up");
				case FlxObject.LEFT:
					this.animation.play("walk_left");
				case FlxObject.RIGHT:
					this.animation.play("walk_right");
			}
		}

		_prevFacing = facing;


	}

	override public function hurt(Damage:Float){
		healthPt -= Std.int(Damage);
		alpha -= 0.05;
		Util.animateDamage(this);

		if (healthPt <= 0){
			if (path != null)
				pausePath();
			alive = false;
			FlxTween.tween(this, { alpha:0 }, 1, { ease: FlxEase.expoOut, onComplete: function(t) kill(), type: FlxTween.ONESHOT });
			_healthBar.kill();
		}
	}

	public function chipDmg(_){
		hurt(0.04);
	}

	private function calculateFacing():Int{
	 	if (velocity.x < 0)
	 		facing = FlxObject.LEFT;
	 	else if (velocity.x > 0) {
	 		facing = FlxObject.RIGHT;
	 	}
	 	else if (velocity.y < 0)
	 		facing = FlxObject.UP;
	 	else if (velocity.y > 0)
	 		facing = FlxObject.DOWN;
	 	else
	 		facing = FlxObject.NONE;

	 	return facing; 
	 }

	/**
	 * Start this enemy on a path, as represented by an array of FlxPoints. Updates position to the first node
	 * and then uses FlxPath.start() to set this enemy on the path. Speed is determined by wave number, unless
	 * in the menu, in which case it's arbitrary.
	 */
	public function followPath(Path:Array<FlxPoint>, X:Int, Y:Int):Void
	{
		if (Path == null)
			throw("No valid path was passed to the enemy! Does the tilemap provide a valid path from start to finish?");
		
		Path[0].x = X;
		Path[0].y = Y;
		
		path = new FlxPath().start(Path, speed, 0, false);
	}

	public function pausePath():Void{
		_savedSpeed = path.speed;
		_savedOnComplete = path.onComplete;
		_savedPath = Util.copyPathFrom(path.nodes, path.nodeIndex);
		_savedPath.insert(0, getMidpoint());
		path.cancel();
		path = null;
	}

	public function resumePath():Void{
 		path = new FlxPath().start(_savedPath, _savedSpeed, 0, false);
		path.onComplete = _savedOnComplete;
		_savedPath = null;
		_savedSpeed = 0;
		_savedOnComplete = null;
	}

	/**
	 *	Starts attacking the tower that is within range until it has died
	 */
	 public function attack(tower:Tower):Void{
	 	if (tower!=null && tower.alive){
	 		// keep attacking the tower at set intervals
	 		isAttacking = true;

			switch (facing){
				case FlxObject.DOWN:
					this.animation.play("attack_down");
				case FlxObject.UP:
					this.animation.play("attack_up");
				case FlxObject.LEFT:
					this.animation.play("attack_left");
				case FlxObject.RIGHT:
					this.animation.play("attack_right");
				default:
					this.animation.play("attack_down");
			}

		}

 		_targetTower = tower;
		animateAttack();

		if (path != null)
 			pausePath();
	 }

	 private function animateAttack(?duration:Float=0.3, ?delay:Float=0.7):Void
	 {
		var targetXDirection = _targetTower.getMidpoint().x == getMidpoint().x? 0 : (_targetTower.getMidpoint().x > getMidpoint().x? 1 : -1); 
		var targetYDirection = _targetTower.getMidpoint().y == getMidpoint().y? 0 :( _targetTower.getMidpoint().y > getMidpoint().y? 1 : -1); 
		var travelDist = Std.int(Util.TILE_SIZE/3);
		var tween = FlxTween.linearPath(this, 
			[FlxPoint.get(x, y), FlxPoint.get(x+targetXDirection*travelDist, y+targetYDirection*travelDist), 
			FlxPoint.get(x, y)], duration, true, {});
		_tween.push(tween);
	 }

}