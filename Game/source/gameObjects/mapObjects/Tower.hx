package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import gameObjects.materials.Material;
import gameObjects.materials.Ammunition;
import gameObjects.materials.TowerBlock;
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
    public var children:List<TowerBlock>; //materials to give back when dismantled
    public var ammo:Ammunition;
    public var numWorkers:Int;
    public var healthPoints:Int;

    private var baseHealth:Int;

    /** Initialize each component of the tower based on materialsList
     */
    public function new(X:Float, Y:Float,materials:List<TowerBlock>, ammo:Ammunition, ?workers:Int=0,
        ?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(X,Y,graphicAsset,graphicsWidth,graphicsHeight);
        this.ammo = ammo;
        this.numWorkers = workers;
        this.children = materials;
        this.healthPoints = getHealth();
        this.baseHealth = this.healthPoints;
        enableInteractable();
    }

    override public function update(elapsed:Float):Void{
        super.update(elapsed);
        var level:Int = 0;
        for (m in children){
            var xpos = this.x+origin.x-m.origin.y;
            var ypos = this.y+origin.y-m.origin.y-level*Constants.HEIGHT_OFFSET;
            level++;
            m.setPosition(xpos,ypos);
        }
    }

    override public function stopDrag():Void {
        super.stopDrag();
        x+=Constants.TILE_WIDTH/2-origin.x;
        y+=Constants.TILE_HEIGHT/2-origin.y;
    }

    public function getFireRateMultiplier():Float{
        return Math.min(numWorkers, Constants.MAX_FIRE_RATE_MULTIPLIER);
    }

    public function takeDamage(obj:Attacker):Void
    {
        if(obj.attackType==AttackType.Ground)
        {
            children.first().takeDamage(obj);
            if(!children.first().alive){
                destroyBottom();
            }
        }
        else if(obj.attackType==AttackType.Air)
        {
            children.last().takeDamage(obj);
            if(!children.last().alive){
                destroyTop();
            }
        }

        if(children.first() == null)
        {
            kill();
        }
    }

    private function destroyBottom():Void
    {
        children.pop();
    }

    private function destroyTop():Void
    {
        children.last();
    }

    private function getHealth():Int{
        var total = 0;
        for (i in this.children){
            total += cast(i,Attackable).healthPoints;
        }

        return total;
    }
}
