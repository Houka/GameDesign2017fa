package gameObjects;

import flixel.FlxG;

/**
 * ...
 * @author ...
 */
class TowerBlock extends Material 
{

	public function new(?X:Float = 0, ?Y:Float = 0, healthPoints:Int, attackPoints:Int)
	{
		super(X, Y, healthPoints, attackPoints);
	}
	
	override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
	
}