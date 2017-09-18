package controllers;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxVector;
import controllers.GameObjectController;
import gameObjects.*;
import gameObjects.Constants;
import gameStates.GameState;
import interfaces.Attacker;
import views.RenderBuffer;
import haxe.macro.Expr;

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

    public function buildTower(materialsList:List<Material>, ammoType:Ammunition, x:Float, y:Float):Null<Tower>
    {
        if(materialsList.length<=0 || materialsList.length>Constants.MAX_HEIGHT){
            return null;
        }
        var tower:Tower = new Tower(materialsList, ammoType, x, y);
        RenderBuffer.buffer.add(tower);

        var level:Int = 0;
        var newLayer:TowerLayer;
        var xpos:Float;
        var ypos:Float;
        for(m in tower.rawMaterials)
        {
            xpos = tower.x+tower.origin.x;
            ypos = tower.y+tower.origin.y-level*Constants.HEIGHT_OFFSET;

            level++;
            if(Type.getClass(m) == Foundation){
                newLayer = new TowerLayer(xpos, ypos, AssetPaths.tower_layer__png, m.healthPoints);
                tower.layers.add(newLayer);
                RenderBuffer.buffer.add(newLayer);
            }
            else if(Type.getClass(m) == GunBase){
                newLayer = new GunLayer(xpos, ypos, AssetPaths.gun_layer__png, m.healthPoints, m.attackPoints, level);
                tower.layers.add(newLayer);
                RenderBuffer.buffer.add(newLayer);
            }
        }
        return tower;
    }

    public function takeDamage(obj:Attacker, tower:Tower):Void
    {
        if(obj.attackType==AttackType.Ground)
        {
            tower.layers.first().takeDamage(obj);
            if(tower.layers.first().isDead){
                destroyBottom(tower);
            }
        }
        else if(obj.attackType==AttackType.Air)
        {
            tower.layers.last().takeDamage(obj);
            if(tower.layers.last().isDead){
                destroyTop(tower);
            }
        }

        if(tower.layers.first() == null)
        {
            tower.isDead = true;
        }
    }

    public function destroyBottom(tower:Tower):TowerLayer
    {
        var dequeued:TowerLayer = tower.layers.pop();
        tower.rawMaterials.pop();

        var level:Int = 0;
        for(l in tower.layers)
        {
            level++;
            l.changeLayerHeight(level);
        }
        return dequeued;
    }

    public function destroyTop(tower:Tower):TowerLayer
    {
        var popped:TowerLayer = tower.layers.last();
        tower.rawMaterials.remove(tower.rawMaterials.last());

        tower.layers.remove(tower.layers.last());
        return popped;
    }

    public function shoot(tower:Tower, dist:Float, xTarget:Float, yTarget:Float):Void
    {
        for(gun in tower.layers)
        {
            if(Type.getClass(gun)==GunLayer)
            {
                //cast(gun, GunLayer);
                if(cast(gun, GunLayer).shoot() && dist<=cast(gun, GunLayer).attackRange){
                    //create bullet type specified by gun.ammoType
                    var bullet:Projectile = new Projectile(gun.x+gun.origin.x, gun.y+gun.origin.y, xTarget, yTarget, 5, 100, true, AssetPaths.fireball__png);
                    RenderBuffer.buffer.add(bullet);
                }
            }
        }
    }

    override public function update(tower:Tower, ?extraArguments:Array<Expr>):Void
    {
        super.update(tower);

        for(npc in GameState.npcs){
            _sight.set(npc.x - tower.x - tower.origin.x, npc.y - tower.y - tower.origin.y);
            
                  if(_sight.length <= tower.layers.length*Constants.RANGE_MULTIPLIER) {
                      // this.shoot(npc.x, npc.y);
                      this.shoot(tower, _sight.length, npc.x, npc.y);
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