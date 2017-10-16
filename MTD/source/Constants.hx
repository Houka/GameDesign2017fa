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
	public static var TILE_SIZE:Int = 64;
	public static var HUD_TEXT_SIZE:Int = 14;
	public static var PS:PlayState;

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

	public static var level1:Level = {
		map:"assets/maps/level1.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8
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

	// Constant functions
	public static function loadMap(lvl:Level, ?IsAuto:Bool = false):FlxTilemap{
		var map = new FlxTilemap();
		if (IsAuto)
			map.loadMapFromCSV(lvl.map, lvl.tilemap, TILE_SIZE, TILE_SIZE, AUTO);
		else
			map.loadMapFromCSV(lvl.map, lvl.tilemap, TILE_SIZE, TILE_SIZE);
		return map;
	}

	public static function toMapCoordinates(x:Float, y:Float):FlxPoint{
		return FlxPoint.get(Std.int(x/TILE_SIZE), Std.int(y/TILE_SIZE));
	}


	/*	Returns the screen coordinates with respect to the camera
	*	x = the column position in map coordinates
	*	y = the row position in map coordinates
	*	where the first column and row is index 0
	*/
	public static function toCameraCoordinates(x:Int, y:Int):FlxPoint{
		return FlxPoint.get(x*TILE_SIZE, y*TILE_SIZE);
	}

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