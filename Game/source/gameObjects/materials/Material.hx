package gameObjects.materials;

import controllers.Controller;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * Material is an abstract class for Foundation, GunBase, and Ammunition.
 * 
 * TODO: Crafting/combining materials
 * 
 */
class Material extends GameObject
{
    public var collected:Bool;

	public function new(?X:Float = 0, ?Y:Float = 0,
		?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
	{
		super(X, Y,graphicAsset,graphicsWidth,graphicsHeight);
        collected = false;
		enableInteractable();
	}

    override public function stopDrag():Void{
        super.stopDrag();
        Controller.addToCollection(this);
    }
}