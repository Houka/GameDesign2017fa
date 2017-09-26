package;

/**
 * Organize all magic numbers.
 *
 * @author Yiming Li
 */

class Constants
{
	//Controller
	static public inline var MAX_GAME_OBJECTS:Int = 500;

    //TowerController
    static public inline var MAX_HEIGHT:Int = 5;
    static public inline var HEIGHT_OFFSET:Float = 16; //the y-distance between layers

    //GunLayer
    static public inline var RANGE_MULTIPLIER:Int = 50;
    static public inline var MAX_FIRE_RATE_MULTIPLIER:Int = 3;

    //MouseController 
    static public inline var TILE_WIDTH = 60; 
	static public inline var TILE_HEIGHT = 60; 

	//Projectile 
	static public inline var PROJECTILE_SPEED = 100;
	static public inline var PROJECTILE_ATTACK = 5; 

	// TEST Vars
	public static inline var PLAYER_TEST_HEALTH = 10;
	public static var TEST_MAP:Array<Int> = [ 	
												2, 1, 1, 1, 1, 1, 1, 1, 1, 1,
												0, 0, 1, 1, 1, 1, 1, 1, 1, 1,
												0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 
												1, 0, 0, 0, 0, 1, 0, 1, 0, 1,
												1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
												1, 1, 0, 0, 0, 3, 0, 0, 0, 0
											];
}