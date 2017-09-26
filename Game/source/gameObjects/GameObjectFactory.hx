package gameObjects;

import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tower;
import gameObjects.materials.TowerBlock;
import gameObjects.materials.Foundation;
import gameObjects.materials.GunBase;
import gameObjects.materials.Ammunition;

/***
* @author: Chang Lu
*/
class GameObjectFactory 
{
    public static function createTower(x:Float, y:Float, materials:List<TowerBlock>, ammoType:Ammunition):Null<Tower>
    {
        if(materials.length <= 0 || materials.length > Constants.MAX_HEIGHT){
        	trace("Error: Cannot build tower without any materials");
        	trace("Error: Cannot build tower with height greater than "+Constants.MAX_HEIGHT);
            return null;
        }

        var tower:Tower = new Tower(x, y, materials, ammoType, 1); // TODO: Remove 1 because im testing with 1 default worker in tower
        
        var level = 0;
        for (m in materials){
            var xpos = tower.x+tower.origin.x;
            var ypos = tower.y+tower.origin.y-level*Constants.HEIGHT_OFFSET;
            level++;
            m.setPosition(xpos,ypos);
            m.disableMouseDrag();
            m.disableMouseClicks();            
            RenderBuffer.add(m);
        }

        return tower;
    }

    public static function createProjectile(obj:GameObject, xTarget:Float, yTarget:Float):Projectile{
    	return new Projectile(obj.x+obj.origin.x, obj.y+obj.origin.y, xTarget, yTarget, 
    		Constants.PROJECTILE_ATTACK, Constants.PROJECTILE_SPEED, false, AssetPaths.fireball__png);
    }
}
