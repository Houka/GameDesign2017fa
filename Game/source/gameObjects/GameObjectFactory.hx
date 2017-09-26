package gameObjects;

import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tower;
import gameObjects.materials.TowerBlock;
import gameObjects.materials.Foundation;
import gameObjects.materials.GunBase;
import gameObjects.materials.Ammunition;
import interfaces.Attacker; 

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

    public static function createRandomTowerBlock(x:Float,y:Float):TowerBlock{
        switch (Std.random(2)) {
            case 0:
                return createGunBase(x,y);
            case 1:
                return createFoundation(x,y);
            default:
                return createFoundation(x,y);
        }
    }

    public static function createGunBase(x:Float,y:Float):GunBase{
        return new GunBase(x,y,10, GunType.Normal,1, AttackType.Ground, 40, 100, AssetPaths.tower_layer__png);
    }

    public static function createFoundation(x:Float,y:Float):Foundation{
        return new Foundation(x,y,10, FoundationType.Wood, AssetPaths.gun_layer__png);
    }

    public static function createAmmunition(x:Float,y:Float):Ammunition{
        return new Ammunition(x,y,AmmoType.Normal,1,AssetPaths.ammo__png, 40, 40);
    }
}
