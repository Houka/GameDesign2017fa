 package controllers;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import gameObjects.*;

/**
 * Tower is an abstract class which provides functionality to the
 * TowerController.
 */

class TowerController extends Tower
{

    public function new(?X:Float=0, ?Y:Float=0, rate:Int, range:Int,
        muzzle:Float, ?attack:Int=0)
    {
        super(X, Y, rate, range, muzzle, attack);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

    }
}