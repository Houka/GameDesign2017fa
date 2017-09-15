package;

import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class Ammunition extends Material
{

	static public var ammoTypes: Array<String> = ["normal", "explosive"];
	public var ammo:String;
	
	override public function new(ammo:String): Void {
		super.create();
		materialTypes = ["normal", "explosive"];
		if (ammo in ammoTypes) {
			this.ammo = ammo;
		}
	}
	
	static public function setAmmo(chosenAmmo:Int): Void { 
		if (chosenAmmo < ammoTypes.length) {
			ammo = ammoTypes[chosenAmmo];
		} 
	}
	
	static public function getAmmo(): String { 
		return ammo;
	}
	
}