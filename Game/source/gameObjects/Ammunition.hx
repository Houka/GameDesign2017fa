package gameObjects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * @author ...
 */
class Ammunition extends Material
{

	static public var ammoTypes: Array<String> = ["normal", "explosive"];
	public var ammo:String;
	
	public function new(?X:Float = 0, ?Y:Float = 0, ammo:String, healthPoints:Int, attackPoints:Int)
	{
		super(X, Y, healthPoints, attackPoints);
		ammoTypes = ["normal", "explosive"];
		this.ammo = ammo;
		
		loadGraphic(AssetPaths.ammo__png, true, 40, 40);
        centerOffsets(true);
        centerOrigin();
	}
	
	public function setAmmo(chosenAmmo:Int): Void { 
		if (chosenAmmo < ammoTypes.length) {
			ammo = ammoTypes[chosenAmmo];
		} 
	}
	
	public function getAmmo(): String { 
		return ammo;
	}
	
	override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
	
}