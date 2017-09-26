 package gameObjects.mapObjects;

 import flixel.FlxG;
 import flixel.system.FlxAssets;
 import gameObjects.GameObject;
 import gameStates.GameState;
 import interfaces.Attackable;
 import interfaces.Attacker;

/**
 * HomeBase stores the player's health, and calls game over when it reaches 0.
 */
class HomeBase extends GameObject implements Attackable
{
    public var healthPoints:Int;

    private var baseHealth:Int;

    public function new(X:Float, Y:Float, healthPoints:Int,?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(X, Y,graphicAsset,graphicsWidth,graphicsHeight);
        this.healthPoints = healthPoints;
        this.baseHealth = healthPoints;
    }

    public function takeDamage(obj:Attacker):Void{
        if (this.alive){
            this.healthPoints -= obj.attackPoints;
        }
        
        if (this.healthPoints <= 0){
            FlxG.switchState(new GameState());
        }
    }

}