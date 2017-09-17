package gameObjects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * ...
 * 
 */
class Foundation extends TowerBlock 
{
	static public var foundationTypes: Array<String> = ["wood", "metal"];
	public var foundation:String;
	
	public function new(?X:Float = 0, ?Y:Float = 0, foundation:String, healthPoints:Int, attackPoints:Int)
	{
		super(X, Y, healthPoints, attackPoints);
		foundationTypes = ["wood", "metal"];
		this.foundation = foundation;
		
		loadGraphic(AssetPaths.wood__png, true, 40, 40);
        centerOffsets(true);
        centerOrigin();
	}
	
	public function setFoundation(chosenFoundation:Int): Void { 
		if (chosenFoundation < foundationTypes.length) {
			foundation = foundationTypes[chosenFoundation];
		} 
	}
	
	public function getFoundation(): String { 
		return foundation;
	}
	
	override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}