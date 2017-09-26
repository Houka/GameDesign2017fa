package gameObjects.materials;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * 
 */
@:enum
abstract FoundationType(Int) {
  var Wood = 0;
  var Metal = 1;
}

class Foundation extends TowerBlock 
{
	public var type:FoundationType;
	
	public function new(?X:Float = 0, ?Y:Float = 0, healthPoints:Int, type:FoundationType, 
		?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
	{
		super(X, Y, healthPoints, graphicAsset, graphicsWidth, graphicsHeight);
		
		this.type = type;
	}
	
	override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}