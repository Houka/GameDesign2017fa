package gameObjects;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

class Bullet extends FlxSprite 
{
	/**
	 * The amount of damage this bullet will do to an enemy. Set only via init().
	 */
	public var damage(default, null):Int;

	public var type:Int=0;
	
	/**
	 * This bullet's targeted enemy. Set via init(), and determines direction of motion.
	 */
	private var _target:Enemy;
	
	/**
	 * Create a new Bullet object. Generally this would be used by the game to create a pool of bullets that can be recycled later on, as needed.
	 */
	public function new() 
	{
		super();
		loadGraphic(AssetPaths.snowball__png, false, 16, 16);
	}
	
	/**
	 * Initialize this bullet by giving it a position, target, and damage amount. Usually used to create a new bullet as it is fired by a tower.
	 * 
	 * @param	X			The desired X position.
	 * @param	Y			The desired Y position.
	 * @param	Target		The desired target, an Enemy.
	 * @param	Damage		The amount of damage this bullet can do, usually determined by the upgrade level of the tower.
	 */
	public function init(X:Float, Y:Float, Target:Enemy, Damage:Int, Type:Int):Void
	{
		reset(X, Y);
		setType(Type);
		_target = Target;
		damage = Damage;
		if (_target != null)
        	angle = FlxAngle.asDegrees(FlxAngle.angleBetweenPoint(this, _target.getMidpoint())) - 90;
        velocity.set(0,0);
        alpha = 1;
	}

	public function setType(Type:Int):Void{
		type = Type;
		switch (Type) {
			case 0:
				loadGraphic(AssetPaths.snowball__png, false, 16, 16);
			case 1:
				loadGraphic(AssetPaths.snowball2__png, false, 16, 16);
			case 2:
				loadGraphic(AssetPaths.snowball3__png, false, 16, 16);
			case 3:
				loadGraphic(AssetPaths.snowball4__png, false, 16, 16);
				damage = 0;
			default:
				loadGraphic(AssetPaths.snowball__png, false, 16, 16);
		}
	}

	public function hurt(e:Enemy):Void{
		switch (type) {
			case 0:
				super.kill();
			case 1:
				// piercing
				_target = null;
				angle += 180;
			case 2:
				// grenade that spawns other normal bullets
				for (i in 0...5){
					var bullet = Constants.PS.collisionController.bullets.recycle(Bullet.new);
					var midpoint = getMidpoint();
					bullet.init(midpoint.x - bullet.origin.x, midpoint.y- bullet.origin.y, null, damage, 0);
					midpoint.put();
					bullet.angle = Std.random(Std.int(360/5*(i+1)));
			        bullet.velocity.set(200, 0);
			        bullet.velocity.rotate(FlxPoint.weak(0,0), bullet.angle);
		    	}
		    	super.kill();
			case 3:
				// slow down enemy
				e.freeze();
				super.kill();
			default:
				super.kill();
		}
	}
	
	override public function update(elapsed:Float):Void
	{
		// This bullet missed its target and flew off-screen; no reason to keep it around.
		
		if (!isOnScreen(FlxG.camera) || alpha <= 0.1) 
		{
			super.kill();
		}
		
		// Move toward the target that was assigned in init().
		
		if (_target!= null && _target.alive)
		{
			FlxVelocity.moveTowardsObject(this, _target, 200);
		}else{
			alpha -= 0.02;
		}
		
		super.update(elapsed);
	}
}