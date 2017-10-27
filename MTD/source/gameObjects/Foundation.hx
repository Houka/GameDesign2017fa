package gameObjects;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;

@:enum
abstract FoundationType(Int) {
  var Wood = 1;
  var Metal = 2;
  var Ice = 3; 
}


class Foundation extends TowerBlock
{
	public var healthPoints:Int; 

	public function new(X:Float, Y:Float, HealthPoints:Int, Asset: String) 
	{
		super(X, Y, Asset);
		this.healthPoints = HealthPoints; 

		#if flash
		blend = BlendMode.NORMAL;
		#end
	}

	public function init(X:Float, Y:Float, HealthPoints:Int):Void
	{
		reset(X, Y);
		healthPoints = HealthPoints; 
	}
	
	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
	}
}