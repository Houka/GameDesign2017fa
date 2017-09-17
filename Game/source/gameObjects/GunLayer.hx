package gameObjects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import interfaces.Attacker;
import gameObjects.TowerLayer;
import gameObjects.Projectile;
import gameObjects.Constants;

/**
 * A GunLayer is a TowerLayer that can shoot
 *
 * TODO: make cooldown framerate independent, change initial rate to 0
 * @author Yiming Li
 */

class GunLayer implements Attacker extends TowerLayer
{
    public var attackPoints:Int;
    public var attackType:AttackType;
    public var attackRange:Int; //should be Float
    public var isAttacking:Bool; //should be private

    public var attackRate:Int;
    public var bullet:Projectile;
    private var _shootCooldown:Int;

    public function new(x:Int, y:Int, graphicAsset:FlxGraphicAsset, hp:Int, atk:Int, layerHeight:Int, ?rate:Int=40)
    {
        super(x,y,graphicAsset,hp);
        this.attackPoints = atk;
        this.attackRange = layerHeight*Constants.RANGE_MULITPLIER;
        this.isAttacking = false;
        this.attackRate = rate;
        this._shootCooldown = 0;
    }

    override public function update(elapsed:Float)
    {
        if(_shootCooldown < attackRate){
            _shootCooldown++;
        }
        else{
            isAttacking = false;
        }
    }

    public function shoot():Bool
    {
        if(_shootCooldown >= attackRate){
            isAttacking = true;
            _shootCooldown = 0;
            return true;
        }
        else{
            return false;
        }
    }

    override public function changeLayerHeight(layerHeight:Int):Void
    {
        attackRange = layerHeight*RANGE_MULITPLIER;
    }

    override public function changeWorkers(numWorkers:Int):Void
    {
        //recalculate the attackRate
    }
}