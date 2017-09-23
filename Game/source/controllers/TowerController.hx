package controllers;

import haxe.macro.Expr;
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

    public function new(frameRate:Int=60):Void
    {
        super(frameRate);
        _sight = new FlxVector();
    }

    public function shoot(tower:Tower, dist:Float, xTarget:Float, yTarget:Float):Void
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

    /**
    *  extraArguments = <list of terrain objs>, ?<list of enemies>
    */
    override public function update(tower:Tower, ?extraArguments:Array<Expr>):Void
    {
        super.update(tower);

        if (extraArguments == null){
            trace("Error: enemy needs <list of terrain objs>, ?<list of workers> for its update... using naive update for enemies");
            //nativeUpdateState(obj);
        }
        else{
            var terrains:Array<Tile> = cast(extraArguments[0]);
            var enemies:Array<Enemy> = cast(extraArguments[1]);

            for(npc in enemies){
                _sight.set(npc.x - tower.x - tower.origin.x, npc.y - tower.y - tower.origin.y);
                
                if(_sight.length <= tower.layers.length*Constants.RANGE_MULTIPLIER) {
                  this.shoot(tower, _sight.length, npc.x, npc.y);
                }
            }
        }
    }

    override private function updateState(tower:Tower, ?extraArguments:Array<Expr>):Void
    {
        super.updateState(tower);

        //tower death sequence
        if(tower.isDead)
        {
            tower.kill();
            //spawn rawMaterials
        }
    }
}