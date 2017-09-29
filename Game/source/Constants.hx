package;

import flixel.math.FlxPoint;
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
    static public inline var TILE_WIDTH = 50; 
	static public inline var TILE_HEIGHT = 50; 

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
	
	public static var HARD_MAP_2:Array<flixel.math.FlxPoint> = [new FlxPoint(200, 300), 
																new FlxPoint(300, 380)];

	public static var HARD_MAP:Array<flixel.math.FlxPoint> =[new FlxPoint(200, 150),
                new FlxPoint(300, 170),
                new FlxPoint(410, 170),
                new FlxPoint(520, 250),
                new FlxPoint(430, 370),
                new FlxPoint(430, 620),
                new FlxPoint(390, 650)];
	
	public static var MED_MAP_2:Array<flixel.math.FlxPoint> = [new FlxPoint(200, 70), 
															new FlxPoint(350, 70), 
															new FlxPoint(280, 120), 
															new FlxPoint(270, 210), 
															new FlxPoint(200, 350), 
															new FlxPoint(260, 450), 
															new FlxPoint(320, 520), 
															new FlxPoint(400, 600), 
															new FlxPoint(400, 700)]; 

	public static var MED_MAP:Array<flixel.math.FlxPoint> =[new FlxPoint(200, 70),
															new FlxPoint(350, 70),
															new FlxPoint(430, 300),
															new FlxPoint(430, 500),
															new FlxPoint(400, 700)];
	public static var EASY_MAP:Array<flixel.math.FlxPoint> =[new FlxPoint(200, 150),
                            new FlxPoint(250, 180),
                            new FlxPoint(280, 280),
                            new FlxPoint(580, 280),
                            new FlxPoint(580, 370),
                            new FlxPoint(470, 370),
                            new FlxPoint(470, 480),
                            new FlxPoint(260, 480),
                            new FlxPoint(240, 550)];
}