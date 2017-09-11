package gameObjects;

import flixel.FlxSprite;
import flixel.system.FlxAssets;
import flixel.math.FlxPoint;

class GameObject extends FlxSprite
{
	public function new(x:Int,y:Int,graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int): Void { 		
		super(x,y);
		loadGraphic(graphicAsset, true, graphicsWidth, graphicsHeight);
	}
}
