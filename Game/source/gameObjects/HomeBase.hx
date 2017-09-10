 package gameObjects;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * HomeBase stores the player's health, and calls game over when it reaches 0.
 */

class HomeBase extends FlxSprite
{
    public hitPoints:Int;

    public function new(hitPoints:Int, ?X:Float=0, ?Y:Float=0,
        ?SimpleGraphic:FlxGraphicAsset)
    {
        super(X, Y, SimpleGraphic);
        this.hitPoints = hitPoints;
    }

    public function takeDamage(atkDmg:Int)
    {
        this.hitPoints -= atkDmg;
        if(hitPoints <= 0){
            trace("Game Over");
        }
    }
}