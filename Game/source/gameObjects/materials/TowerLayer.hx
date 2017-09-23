package gameObjects.materials;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import interfaces.Attackable;
import interfaces.Attacker;
import gameObjects.GameObject;

/**
 * A TowerLayer represents a material in action as part of a Tower.
 *
 * @author Yiming Li
 */

class TowerLayer implements Attackable extends GameObject
{
    private var baseHealth:Int; //please change to _baseHealth
    public var healthPoints:Int;
    public var isDead:Bool;

    public function new(x:Float, y:Float, graphicAsset:FlxGraphicAsset, hp:Int)
    {
        super(x,y,graphicAsset);
        this.baseHealth = hp;
        this.healthPoints = hp;
        this.isDead = false;
    }

    public function takeDamage(obj:Attacker):Void
    {
        healthPoints -= obj.attackPoints;
        if(healthPoints <= 0)
        {
            isDead = true;
        }
    }

    public function changeLayerHeight(layerHeight:Int):Void
    {

    }

    public function changeWorkers(numWorkers:Int):Void
    {

    }

}