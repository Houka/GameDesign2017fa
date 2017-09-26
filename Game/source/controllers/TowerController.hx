package controllers;

import haxe.macro.Expr;
import haxe.ds.GenericStack;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxVector;
import gameObjects.mapObjects.Tower;
import gameObjects.mapObjects.Tile;
import gameObjects.materials.GunLayer;
import gameObjects.npcs.Enemy;
import gameObjects.GameObjectFactory;
import interfaces.Attacker;

/**
 * TowerController oversees all towers and contains functions to manipulate
 * TowerLayers.
 *
 * @author Yiming Li
 */

class TowerController extends GameObjectController<Tower>
{
    private var _sight:FlxVector;

    public function new(maxSize:Int=0, frameRate:Int=60):Void
    {
        super(maxSize,frameRate);
        _sight = new FlxVector();
    }

    public function canTargetEnemy(tower:Tower, enemy:Enemy):Bool{
        _sight.set(enemy.x - tower.x - tower.origin.x, enemy.y - tower.y - tower.origin.y);

        if(_sight.length <= tower.layers.length*Constants.RANGE_MULTIPLIER) {
            shoot(tower, _sight.length, enemy.x, enemy.y);
            return true;
        }

        return false;
    }

    private function shoot(tower:Tower, dist:Float, xTarget:Float, yTarget:Float):Void
    {
        for(gun in tower.layers)
        {
            if(Type.getClass(gun)==GunLayer)
            {
                if(cast(gun, GunLayer).shoot() && dist<=cast(gun, GunLayer).attackRange){
                    //create bullet type specified by gun.ammoType
                    RenderBuffer.add(GameObjectFactory.createProjectile(tower,xTarget,yTarget));
                }
            }
        }
    }
}