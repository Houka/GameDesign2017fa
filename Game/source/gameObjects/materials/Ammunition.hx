package gameObjects.materials;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * 
 */@:enum
abstract AmmoType(Int) {
  var Normal = 0;
  var Explosive = 1;
}

class Ammunition extends Material
{

	public var type: AmmoType;
	public var attackPoints:Int;
	
	public function new(X:Float = 0, Y:Float = 0, type:AmmoType, attackPoints:Int,
		?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
	{
		super(X, Y, graphicAsset,graphicsWidth,graphicsHeight);
		this.type = type;
		this.attackPoints = attackPoints;
	}
}