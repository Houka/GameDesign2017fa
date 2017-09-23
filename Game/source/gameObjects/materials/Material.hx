package gameObjects.materials;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import interfaces.Interactable;

/**
 * Material is an abstract class for Foundation, GunBase, and Ammunition.
 * 
 * TODO: Crafting/combining materials
 * 
 */
class Material extends GameObject implements Interactable
{
	
	public function new(?X:Float = 0, ?Y:Float = 0,?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
	{
		super(X, Y,graphicAsset,graphicsWidth,graphicsHeight);
	}		

	public function hovered():Void{}
	public function selected(point: FlxPoint):Void{}
	public function released():Void{}
}