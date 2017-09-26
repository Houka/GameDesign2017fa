package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxG;

/**
 * @author Chang Lu
 */

class Inventory extends GameObject
{
    /** Initialize each component of the tower based on materialsList
     */
    public function new(X:Float, Y:Float, ?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(X,Y,graphicAsset,graphicsWidth,graphicsHeight);
        createTestInventory();
    }

    // TODO: remove test function
    private function createTestInventory():Void
    {
        makeGraphic(cast((FlxG.width*3)/4),cast(FlxG.height/4), FlxColor.WHITE, true);
        FlxSpriteUtil.drawRect(this,0,FlxG.height*3./4.,FlxG.width*3./4.,FlxG.height/4);
        updateHitbox();
    }
}
