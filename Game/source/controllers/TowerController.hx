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

    override public function updateState(obj:Tower){
        super.updateState(obj);
        shoot(obj);
    }

    

    private function shoot(tower:Tower):Void
    {
        var level = 0;
        for(gun in tower.children)
        {
            level ++;
            if(Type.getClass(gun)==GunBase && cast(gun, GunBase).canShoot(tower.getFireRateMultiplier()))
                gunBaseShoot(cast(gun,GunBase));
        }
    }

    private function gunBaseShoot(gun:GunBase){
        var x = gun.x + gun.origin.x;
        var y = gun.y + gun.origin.y;
        switch(gun.type){
            case Vertical:
                RenderBuffer.add(GameObjectFactory.createProjectile(gun, x+100, y, gun.baseAttackRange));              
                RenderBuffer.add(GameObjectFactory.createProjectile(gun, x-100, y, gun.baseAttackRange));              
            case Horizontal:
                RenderBuffer.add(GameObjectFactory.createProjectile(gun, x, y+100, gun.baseAttackRange));              
                RenderBuffer.add(GameObjectFactory.createProjectile(gun, x, y-100, gun.baseAttackRange));              
            case Diagonal:
                RenderBuffer.add(GameObjectFactory.createProjectile(gun, x+100, y+100, gun.baseAttackRange));              
                RenderBuffer.add(GameObjectFactory.createProjectile(gun, x-100, y-100, gun.baseAttackRange));              
                RenderBuffer.add(GameObjectFactory.createProjectile(gun, x-100, y+100, gun.baseAttackRange));              
                RenderBuffer.add(GameObjectFactory.createProjectile(gun, x+100, y-100, gun.baseAttackRange));
        }
    }
}