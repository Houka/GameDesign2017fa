package gameObjects;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxVelocity;
import flixel.system.FlxAssets;
import AssetPaths;


class TowerBlock extends FlxSprite 
{
	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);		
		#if flash
		blend = BlendMode.INVERT;
		#end
	}
	
	override public function update(elapsed:Float):Void
	{	
		super.update(elapsed);
	}
}