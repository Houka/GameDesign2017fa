package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxG;
import gameObjects.mapObjects.Tower;

/**
 * @author Chang Lu
 */

class BuildArea extends GameObject
{
    /** Initialize each component of the tower based on materialsList
     */
    public function new(X:Float, Y:Float, ?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(X,Y,graphicAsset,graphicsWidth,graphicsHeight);
        updateHitbox();
    }
}
