package;

import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import gameStates.PlayState;
import AssetPaths;

/*
*	typedefs used across several files
*/
typedef Level = {
	var map: String; 			// path to csv file for this level
	var mapWidth:Int;
	var mapHeight:Int;
	var tilemap: String;		// path to tilemap for this level
	var start: FlxPoint;
	var goal: FlxPoint;
	var health: Int;			// how much health does homebase have
	var money: Int; 			// starting money
	var defaultTowerPrice: Int;
	@:optional var isTutorial: Bool; 
	//@:optional var buttonsAvail: List<Int>; 	// buttons available at each stage (indicated by index)
}

enum CursorType
{
	Normal;
	Build;
	Destroy;
}

/*
*	vars and functions used across several files
*/
class Constants{
	// Constants vars
	static public inline var MAX_HEIGHT:Int = 5;
	static public inline var HEIGHT_OFFSET:Float = 25; //the y-distance between layers

	// Level data
	public static var demo:Level = {
		map:"assets/maps/demo.csv",
		mapWidth: 40,
		mapHeight:30,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),					 
		goal: toCameraCoordinates(34,29),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	public static var tutorial:Level = {
		map:"assets/maps/level1.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 1,
		defaultTowerPrice: 1, 
		isTutorial: true
		//buttonsAvail: 0
	}

	public static var level1:Level = {
		map:"assets/maps/level1.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 1,
		defaultTowerPrice: 1, 
		//buttonsAvail: 0
	}

	public static var level2:Level = {
		map:"assets/maps/level2.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	public static var level3:Level = {
		map:"assets/maps/level3.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	public static var level4:Level = {
		map:"assets/maps/level4.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 2,
		defaultTowerPrice: 8
	}

	public static var level5:Level = {
		map:"assets/maps/level5.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	public static var level6:Level = {
		map:"assets/maps/level6.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	public static var level7:Level = {
		map:"assets/maps/level7.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	public static var level8:Level = {
		map:"assets/maps/level8.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	public static var level9:Level = {
		map:"assets/maps/level9.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	public static var level10:Level = {
		map:"assets/maps/level10.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
	}

	static public inline var HEIGHT_OFFSET:Float = 15; //the y-distance between layers
	static public inline var TILE_SIZE:Int = 64;
	static public inline var HUD_TEXT_SIZE:Int = 14;

	public static var PS:PlayState;
	
	// Constant functions
	public static function toggleCursors(Type:CursorType):Void{
		switch(Type){
			case Normal:
				FlxG.mouse.load(AssetPaths.cursor__png);
			case Build:
				FlxG.mouse.load(AssetPaths.cursor_build__png);
			case Destroy:
				FlxG.mouse.load(AssetPaths.cursor_destroy__png);
			default:
				FlxG.mouse.load(AssetPaths.cursor__png);
		}
	}

	/*
	*	Plays background music
	*	Neko and html5 does not support playing mp3 files
	*/
	public static function playMusic(filename:String):Void {
		FlxG.sound.playMusic("assets/sounds/"+filename+".ogg");
	}

	/*
	*	Plays sound effects
	*	Neko and html5 does not support playing mp3 files
	*/
	public static function play(filename:String):Void {
		FlxG.sound.play("assets/sounds/"+filename+".ogg");
	}
	
	/**
	 * The select sound gets played from a lot of places, so it's in a convenient function.
	 */
	public static function playSelectSound():Void
	{
		Constants.play("select");
	} 
}