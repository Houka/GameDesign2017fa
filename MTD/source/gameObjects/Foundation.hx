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


class Foundation extends TowerBlock
{
	public var type:FoundationType; 

	public function new(X:Float, Y:Float) 
	{
		super(X, Y, AssetPaths.tower_base__png);
		
		#if flash
		blend = BlendMode.INVERT;
		#end
	}

	public function init(X:Float, Y:Float, Type:FoundationType):Void
	{
		reset(X, Y);
		type = Type; 
	}
	
	override public function update(elapsed:Float):Void
	{		
		super.update(elapsed);
	}
}