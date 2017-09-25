package gameObjects;

import flixel.addons.display.FlxExtendedSprite;
import flixel.system.FlxAssets;
import flixel.math.FlxPoint;
import flixel.FlxG;

class GameObject extends FlxExtendedSprite
{
	public function new(x:Float,y:Float,?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int): Void { 		
		super(x,y);
		if (graphicAsset != null) loadGraphic(graphicAsset, true, graphicsWidth, graphicsHeight);
	}

	public function centerToOrigin():Void{
        centerOffsets(true);
        centerOrigin();

        setPosition(x-origin.x, y-origin.y);
	}

	override public function stopDrag():Void{
		super.stopDrag();
		if (_snapOnRelease)
		{
			x = (Math.floor(FlxG.mouse.x / _snapX) * _snapX);
			y = (Math.floor(FlxG.mouse.y / _snapY) * _snapY);
		}
	}

	private function enableInteractable():Void{
		enableMouseClicks(true);
		enableMouseDrag(true);
		enableMouseSnap(Constants.TILE_WIDTH, Constants.TILE_HEIGHT,false,true);
	}
}
