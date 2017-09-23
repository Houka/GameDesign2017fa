package gameObjects;

import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tower;
import gameObjects.materials.Material;
import gameObjects.materials.Foundation;
import gameObjects.materials.TowerLayer;
import gameObjects.materials.GunBase;
import gameObjects.materials.GunLayer;
import gameObjects.materials.Ammunition;

/***
* @author: Chang Lu
*/
class GameObjectFactory 
{
    public static function createTower(materialsList:List<Material>, ammoType:Ammunition, x:Float, y:Float):Null<Tower>
    {
        if(materialsList.length<=0 || materialsList.length>Constants.MAX_HEIGHT){
        	trace("Error: Cannot build tower without any materials");
        	trace("Error: Cannot build tower with height greater than "+Constants.MAX_HEIGHT);
            return null;
        }
        var tower:Tower = new Tower(materialsList, ammoType, x, y);
        RenderBuffer.add(tower);

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
                newLayer = new TowerLayer(xpos, ypos, AssetPaths.tower_layer__png, 
                    cast(m,Foundation).healthPoints);
                tower.layers.add(newLayer);
                RenderBuffer.add(newLayer);
            }
            else if(Type.getClass(m) == GunBase){
                newLayer = new GunLayer(xpos, ypos, AssetPaths.gun_layer__png, 
                    cast(m,GunBase).healthPoints, cast(m,GunBase).attackPoints, level);
                tower.layers.add(newLayer);
                RenderBuffer.add(newLayer);
            }
        }
        return tower;
    }

    public static function createProjectile(obj:GameObject, xTarget:Float, yTarget:Float):Projectile{
    	return new Projectile(obj.x+obj.origin.x, obj.y+obj.origin.y, xTarget, yTarget, 
    		Constants.PROJECTILE_ATTACK, Constants.PROJECTILE_SPEED, false, AssetPaths.fireball__png);
    }
}
