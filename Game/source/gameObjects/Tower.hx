package gameObjects;

import flixel.FlxSprite;
import gameObjects.TowerLayer;
import gameObjects.Material;
import gameObjects.Ammunition;

/**
 * Tower contains a collection of TowerLayers; it also holds the position and
 * hitbox of the overall tower.
 *
 * TODO: set hitboxes with Chang
 * @author Yiming Li
 */

class Tower extends FlxSprite
{
    public var layers:List<TowerLayer>;
    public var ammoType:Ammunition;
    public var rawMaterials:List<Material>; //materials to give back when dismantled
    public var isDead:Bool;

    /** Initialize each component of the tower based on materialsList
     */
    public function new(materialsList:List<Material>, ammoType:Ammunition, ?X:Float=0, ?Y:Float=0)
    {
        super(X,Y);
        this.ammoType = ammoType;
        this.rawMaterials = materialsList;
        this.isDead = false;
        //initialize layers in TowerController
    }
}
