package controllers;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxVector;
import flixel.FlxG;
import controllers.GameObjectController;
import gameObjects.*;
import gameStates.GameState;
import Math.*; 

/**
 * TowerController oversees all towers and contains functions to manipulate
 * TowerLayers.
 *
 * @author Yiming Li
 */

class TowerController extends GameObjectController<Tower>
{
    public function new(frameRate:Int=60):Void{
        super(frameRate);
    }

    public function buildTower(materialsList:List<Material>, x:Float, y:Float):Bool
    {
        if(materialsList.length<=0 || materialsList.length>MAX_HEIGHT){
            return false;
        }
        var tower = new(materialsList:List<Material>, x, y);

        var level:Int = 0;
        for(m in tower.materialsList)
        {
            var xpos = x+origin.x;
            var ypos = y+origin.y+level*HEIGHT_OFFSET;
            level++;
            if(getClassName(m) == FOUNDATION_CLASSPATH){
                //layers.add(new TowerLayer(xpos, ypos, AssetPaths));
            }
            else if(getClassName(m) == GUNLAYER_CLASSPATH){
                //layers.add(new GunLayer(xpos, ypos, ));
            }
        }
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
            l.changeHeight();
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

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
		
        /*sight.set(FlxG.mouse.x - x - origin.x, FlxG.mouse.y - y -origin.y);
		if(sight.length <= this.range){
            this.shoot(FlxG.mouse.x, FlxG.mouse.y);
        }*/
		
		if (GameState.npcs[0] != null) {
			//trace(GameState.npcs[0].getX());
			sight.set(GameState.npcs[0].getX() - x - origin.x, GameState.npcs[0].getY() - y - origin.y);
			
			if(sight.length <= this.range) {
				this.shoot(GameState.npcs[0].getX(), GameState.npcs[0].getY());
			}
		}
		
    }

    private function random(from:Int, to:Int): Int { 
        return from + Math.floor(((to - from + 1) * Math.random()));
    }
	
}