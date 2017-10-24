package gameObjects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxPath;
import flixel.math.FlxPoint;
import ui.HUD;
import AssetPaths;
import Constants;

class Enemy extends FlxSprite 
{
	// animation vars
	private static inline var _framerate:Int = 5;

	public var maxHealth:Float = 1.0;
	public var attackBase:Float = 0.5;
	public var attackRange:Int = Constants.TILE_SIZE;
	public var isAttacking:Bool = false;

	// path variables
	private var _savedPath:Array<FlxPoint>;
	private var _savedSpeed:Float;
	private var _savedOnComplete:FlxPath->Void;

	// movement vars
	private var _prevFacing:Int;

	// attacking vars
	private var _targetTower:Tower;
	private var _attackInterval:Int = 1;
	private var _attackCounter:Int = 0;

	
	/**
	 * Create a new enemy. Used in the menu and playstate.
	 */
	override public function new(X:Float = 0, Y:Float = 0) 
	{
		super(X, Y);
		loadGraphic(AssetPaths.enemy_spritesheet_64x64__png, true, 64, 64);
		health = maxHealth;
		init(X,Y);
	}
	
	/**
	 * Reset this enemy at X,Y and reset their health. Used for object pooling in the PlayState.
	 */
	public function init(X:Float, Y:Float)
	{
		reset(X, Y);
		
		if (Constants.PS != null)
			health = Math.floor(Constants.PS.wave / 3) + 1;
		
		maxHealth = health;
		isAttacking = false;
		_targetTower = null;

		// reset path vars
		_savedPath = null;
		_savedSpeed = 0;
		_savedOnComplete = null;

		// add animations
		animation.add("idle",[0],_framerate, false);
		animation.add("attack",[15],_framerate, false);
		animation.add("walk_down",[0,1,2,3,4],_framerate, true);
		animation.add("walk_left",[5,6,7,8,9],_framerate, true);
		animation.add("walk_right",[10,11,12,13,14],_framerate, true);
		animation.add("walk_up",[15,16,17,18,19],_framerate, true);

		animation.play("idle");
		_prevFacing = facing;
	}
	
	/**
	 * The alpha of the enemy is dependent on health.
	 */
	override public function update(elapsed:Float):Void
	{
		alpha = health / maxHealth; 

		// what to do during attacking state

		if (isAttacking){
			_attackCounter += Std.int(FlxG.timeScale);

			if (_attackCounter > (_attackInterval * FlxG.updateFramerate)){
				_targetTower.hurt(attackBase);
				_attackCounter = 0;
			}

		 	// stop attacking a dead tower and go back to path
			if (_targetTower!=null && !_targetTower.alive){
				// resume path
		 		path = new FlxPath().start(_savedPath, _savedSpeed, 0, true);
				path.onComplete = _savedOnComplete;
				_savedPath = null;
				_savedSpeed = 0;
				_savedOnComplete = null;

				// stop attacking
		 		isAttacking = false;
		 		_targetTower = null;
	 		}
		}

		// update animations based on where we are facing if we changed facing directions
		calculateFacing();
		if (isAttacking){
			animation.play("attack");
		}
		else if (_prevFacing != facing){
			switch (facing){
				case FlxObject.DOWN:
					animation.play("walk_down");
				case FlxObject.UP:
					animation.play("walk_up");
				case FlxObject.LEFT:
					animation.play("walk_left");
				case FlxObject.RIGHT:
					animation.play("walk_right");
				default:
					animation.play("idle");
			}
		}

		_prevFacing = facing;

		super.update(elapsed);
	}
	
	/**
	 * Inflict horrible pain on this enemy
	 * 
	 * @param	Damage	The damage to deal to this enemy.
	 */
	override public function hurt(Damage:Float):Void
	{
		health -= Damage;
		
		if (health <= 0)
			explode(true);
	}
	
	/**
	 * Called on this enemy's death. Recycles and emits particles, updates the number of enemies left,
	 * finishes the wave if it was the last enemy, and awards money as appropriate.
	 * 
	 * @param	GainMoney	Whether or not this enemy should give the player money. True if killed by a tower, false if killed by colliding with the goal.
	 */
	public function explode(GainMoney:Bool):Void
	{
		FlxG.sound.play("enemykill");
		
		var emitter = Constants.PS.emitters.recycle(EnemyExplosion.new);
		emitter.startAtPosition(x, y);
		
		Constants.PS.enemiesToKill--;
		
		if (Constants.PS.enemiesToKill <= 0)
			Constants.PS.killedWave();
		
		if (GainMoney)
		{
			var money:Int = (Constants.PS.wave < 5) ? 2 : 1;
			HUD.money += money;
		}
		
		super.kill();
	}
	
	/**
	 * Start this enemy on a path, as represented by an array of FlxPoints. Updates position to the first node
	 * and then uses FlxPath.start() to set this enemy on the path. Speed is determined by wave number, unless
	 * in the menu, in which case it's arbitrary.
	 */
	public function followPath(Path:Array<FlxPoint>, Speed:Int, ?OnComplete:FlxPath->Void):Void
	{
		if (Path == null)
			throw("No valid path was passed to the enemy! Does the tilemap provide a valid path from start to finish?");
		
		Path[0].x = x;
		Path[0].y = y;
		
		path = new FlxPath().start(Path, Speed, 0, false);
		path.onComplete = OnComplete;
	}


	public function pausePath():Void{
		_savedSpeed = path.speed;
		_savedOnComplete = path.onComplete;
		_savedPath = copyPathFrom(path.nodes, path.nodeIndex);
		_savedPath.insert(0, getMidpoint());
		path.cancel();
		path = null;
	}

	/**
	 *	Starts attacking the tower that is within range until it has died
	 */
	 public function attack(tower:Tower):Void{
	 	if (tower!=null && tower.alive){
	 		// keep attacking the tower at set intervals
	 		isAttacking = true;

	 		// TODO: add attacking animation play here
	 		_targetTower = tower;

	 		pausePath();
	 	}
	 }

	 private function copyPathFrom(Path:Array<FlxPoint>,Index:Int):Array<FlxPoint>{
		var result:Array<FlxPoint> = new Array<FlxPoint>();
		var tempPoint:FlxPoint;
		for (i in Index...Path.length){
			tempPoint = new FlxPoint(Path[i].x,Path[i].y);
			result.push(tempPoint);
		}

		return result;
	 }

	 private function calculateFacing():Int{
	 	if (velocity.x < 0)
	 		facing = FlxObject.LEFT;
	 	else if (velocity.x > 0)
	 		facing = FlxObject.RIGHT;
	 	else if (velocity.y < 0)
	 		facing = FlxObject.UP;
	 	else if (velocity.y > 0)
	 		facing = FlxObject.DOWN;
	 	else
	 		facing = FlxObject.NONE;

	 	return facing; 
	 }
}