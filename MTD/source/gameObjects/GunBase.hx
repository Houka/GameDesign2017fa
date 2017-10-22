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

class GunBase extends TowerBlock 
{
	public var type: GunType;
	public var attackPoints: Int; 
	public var attackRange: Int; 
	public var attackRate: Int; 
	private var _shotCooldown: Int; 


	public function new(X:Float, Y:Float) 
	{
		super(X, Y, AssetPaths.gun__png);
		
		#if flash
		blend = BlendMode.INVERT;
		#end
	}
	

	public function init(X:Float, Y:Float, Type:GunType, AttackPoints:Int, AttackRange:Int, AttackRate:Int):Void
	{
		reset(X, Y);
		type = Type; 
		attackPoints = AttackPoints; 
		attackRange = AttackRange; 
		attackRate = AttackRate; 
	}
	
	override public function update(elapsed:Float):Void
	{	
		super.update(elapsed);
	}
}