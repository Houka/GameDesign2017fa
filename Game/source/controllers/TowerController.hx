package controllers;

import haxe.macro.Expr;
import haxe.ds.GenericStack;
import flixel.FlxSprite;
import flixel.addons.display.FlxExtendedSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxVector;
import controllers.Controller;
import gameObjects.mapObjects.Tower;
import gameObjects.mapObjects.Tile;
import gameObjects.mapObjects.BuildArea;
import gameObjects.materials.GunBase;
import gameObjects.materials.TowerBlock;
import gameObjects.materials.Ammunition;
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

        if(_sight.length <= tower.children.length*Constants.RANGE_MULTIPLIER) {
            shoot(tower, _sight.length, enemy.x, enemy.y);
            return true;
        }

        return false;
    }

    private function shoot(tower:Tower, dist:Float, xTarget:Float, yTarget:Float):Void
    {
        var level = 0;
        for(gun in tower.children)
        {
            level ++;
            if(Type.getClass(gun)==GunBase && 
                    cast(gun, GunBase).canShoot(tower.getFireRateMultiplier()) && 
                    dist <= cast(gun, GunBase).baseAttackRange*level)
                RenderBuffer.add(GameObjectFactory.createProjectile(gun,xTarget,yTarget));
             
        }
    }
}