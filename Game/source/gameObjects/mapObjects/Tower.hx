package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import gameObjects.materials.TowerLayer;
import gameObjects.materials.Material;
import gameObjects.materials.Ammunition;
import interfaces.Attackable;
import interfaces.Attacker;

/**
 * Tower contains a collection of TowerLayers; it also holds the position and
 * hitbox of the overall tower.
 *
 * TODO: set hitboxes with Chang
 * @author Yiming Li
 */

class Tower extends GameObject implements Attackable
{
    public var layers:List<TowerLayer>;
    public var ammoType:Ammunition;
    public var numWorkers:Int;
    public var rawMaterials:List<Material>; //materials to give back when dismantled
    public var isDead:Bool;
    public var healthPoints:Int;

    private var baseHealth:Int;

    /** Initialize each component of the tower based on materialsList
     */
    public function new(materialsList:List<Material>, ammoType:Ammunition, X:Float, Y:Float)
    {
        super(X,Y);
        layers = new List<TowerLayer>(); //populate layers in TowerController
        this.ammoType = ammoType;
        this.numWorkers = 0;
        this.rawMaterials = materialsList;
        this.isDead = false;
        this.healthPoints = getHealth();
        this.baseHealth = this.healthPoints;
    }

    public function takeDamage(obj:Attacker):Void
    {
        if(obj.attackType==AttackType.Ground)
        {
            this.layers.first().takeDamage(obj);
            if(this.layers.first().isDead){
                destroyBottom();
            }
        }
        else if(obj.attackType==AttackType.Air)
        {
            this.layers.last().takeDamage(obj);
            if(this.layers.last().isDead){
                destroyTop();
            }
        }

        if(this.layers.first() == null)
        {
            this.isDead = true;
            kill();
        }
    }

    private function destroyBottom():TowerLayer
    {
        var dequeued:TowerLayer = this.layers.pop();
        this.rawMaterials.pop();

        var level:Int = 0;
        for(l in this.layers)
        {
            level++;
            l.changeLayerHeight(level);
        }
        return dequeued;
    }

    private function destroyTop():TowerLayer
    {
        var popped:TowerLayer = this.layers.last();
        this.rawMaterials.remove(this.rawMaterials.last());

        this.layers.remove(this.layers.last());
        return popped;
    }

    private function getHealth():Int{
        var total = 0;
        for (i in this.rawMaterials){
            total += cast(i,Attackable).healthPoints;
        }

        return total;
    }
}
