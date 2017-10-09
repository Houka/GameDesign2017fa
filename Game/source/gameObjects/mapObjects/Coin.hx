package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxG;

/**
 * @author Chang Lu
 */

class Coin extends GameObject
{
    public static var CAN_TIMEOUT:Bool = false;
    public var value:Int;
    private var disappearCoundown:Int;

    /** Initialize each component of the tower based on materialsList
     */
    public function new(X:Float, Y:Float, value:Int, ?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(X,Y,graphicAsset,graphicsWidth,graphicsHeight);
        this.value= value;
        this.enableMouseClicks(true);
        this.disappearCoundown = 500;
    }

    override public function update(elapsed:Float):Void{
        super.update(elapsed);

        if (Coin.CAN_TIMEOUT)
            timeout();

        if (mouseOver && alive){
            alive = false;
            HUD.CURRENCY_AMOUNT ++;
        }

        if (!alive){
            y -=2;
            alpha -= 0.1;
        }

        if (!alive && alpha <= 0){
            kill();
            destroy();
        }
    }

    // call if we want to have a coin disappear after a certain time
    private function timeout():Void{
        disappearCoundown --;
        if (disappearCoundown <= 0)
            alive = false; 
    }
}