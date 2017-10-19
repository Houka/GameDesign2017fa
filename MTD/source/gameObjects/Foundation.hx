package gameObjects;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;

@:enum
abstract FoundationType(Int) {
  var Wood = 0;
  var Metal = 1;
}


class Foundation extends FlxSprite 
{
	public var type:FoundationType; 
	private var healthPoints:Int; 

	public function new(X:Float, Y:Float) 
	{
		super(X, Y, AssetPaths.tower_base__png);
		
		#if flash
		blend = BlendMode.INVERT;
		#end
	}

	public function init(X:Float, Y:Float, HealthPoints:Int, Type:FoundationType):Void
	{
		reset(X, Y);
		healthPoints = HealthPoints; 
		type = Type; 
	}
	
	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
	}
}