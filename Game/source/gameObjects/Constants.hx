package gameObjects;

/**
 * Organize all magic numbers.
 *
 * @author Yiming Li
 */

class Constants
{
    //TowerController
    static public inline var MAX_HEIGHT:Int = 5;
    static public inline var HEIGHT_OFFSET:Float = 16; //the y-distance between layers

    //GunLayer
    static public inline var RANGE_MULTIPLIER:Int = 50;

    //MouseController 
    static public inline var TILE_WIDTH = 60; 
	static public inline var TILE_HEIGHT = 60; 

	// TEST Vars
	public static var TEST_MAP:Array<Int> = [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
									0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
									0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 
									1, 1, 0, 0, 0, 1, 0, 1, 0, 1,
									1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
									1, 1, 0, 0, 0, 0, 0, 0, 0, 0];
}