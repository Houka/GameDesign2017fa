package gameObjects;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import AssetPaths;

@:enum
abstract GunType(Int) {
  var Horizontal = 0;  // - shape
  var Vertical = 1;  // | shape
  var Diagonal = 2;   // x shape
}

class GunBase extends FlxSprite 
{
	public var healthPoints: Int;  
	public var type: GunType;
	public var attackPoints: Int; 
	public var attackRange: Int; 
	public var attackRate: Int; 
	private var _shotCooldown: Int; 
	/**
	 * The amount of damage this bullet will do to an enemy. Set only via init().
	 */
	// public var damage(default, null):Int;
	
	/**
	 * This bullet's targeted enemy. Set via init(), and determines direction of motion.
	 */
	// private var _target:Enemy;
	
	/**
	 * Create a new GunBase object. Generally this would be used by the game to create a pool of GunBases that can be recycled later on, as needed.
	 */
	public function new(X:Float, Y:Float) 
	{
		super(X, Y, AssetPaths.gun__png);
		
		#if flash
		blend = BlendMode.INVERT;
		#end
	}
	
	/**
	 * Initialize this bullet by giving it a position, target, and damage amount. Usually used to create a new bullet as it is fired by a tower.
	 * 
	 * @param	X			The desired X position.
	 * @param	Y			The desired Y position.
	 * @param	Target		The desired target, an Enemy.
	 * @param	Damage		The amount of damage this bullet can do, usually determined by the upgrade level of the tower.
	 */
	public function init(X:Float, Y:Float, HealthPoints:Int, Type:GunType, AttackPoints:Int, AttackRange:Int, AttackRate:Int):Void
	{
		reset(X, Y);
		healthPoints = HealthPoints; 
		type = Type; 
		attackPoints = AttackPoints; 
		attackRange = AttackRange; 
		attackRate = AttackRate; 
	}
	
	override public function update(elapsed:Float):Void
	{
		// This bullet missed its target and flew off-screen; no reason to keep it around.
		
	// 	if (!isOnScreen(FlxG.camera)) 
	// 	{
	// 		kill();
	// 	}
		
	// 	// Move toward the target that was assigned in init().
		
	// 	if (_target.alive)
	// 	{
	// 		FlxVelocity.moveTowardsObject(this, _target, 200);
	// 	}
		
		super.update(elapsed);
	}
}