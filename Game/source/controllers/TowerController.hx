 package controllers;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.math.FlxVector;
 import flixel.FlxG;
 import gameObjects.*;

/**
 * Tower is an abstract class which provides functionality to the
 * TowerController.
 */

class TowerController extends Tower
{
    public var sight:FlxVector;

    public function new(?X:Float=0, ?Y:Float=0, rate:Int, range:Int,
        muzzle:Float, ?attack:Int=0)
    {
        super(X, Y, rate, range, muzzle, attack);
        this.sight = new FlxVector();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        sight.set(FlxG.mouse.x - x - origin.x, FlxG.mouse.y - y - origin.y);
        if(sight.length <= this.range){
            this.shoot(FlxG.mouse.x, FlxG.mouse.y);
        }
    }
}