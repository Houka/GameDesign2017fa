package gameObjects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * 
 */
class GunBase extends TowerBlock 
{

	static public var gunbaseTypes: Array<String> = ["normal", "spray", "heavy"];
	public var gunbase:String;
	
	public function new(?X:Float = 0, ?Y:Float = 0, gunbase:String, healthPoints:Int, attackPoints:Int)
	{
		super(X, Y, healthPoints, attackPoints);
		gunbaseTypes = ["normal", "spray", "heavy"];
		this.gunbase = gunbase;
		
		loadGraphic(AssetPaths.gunbase__png, true, 40, 40);
        centerOffsets(true);
        centerOrigin();
	}
	
	public function setGunbase(chosenGunbase:Int): Void { 
		if (chosenGunbase < gunbaseTypes.length) {
			gunbase = gunbaseTypes[chosenGunbase];
		} 
	}
	
	public function getGunbase(): String { 
		return gunbase;
	}
	
	override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
	
}