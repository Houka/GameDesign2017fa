package;

import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import Constants.TILE_SIZE;

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

class Levels{
	// Level data
	public static var demo(default,never):Level = {	// demo level used for menu
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

	public static var level1(default,never):Level = {
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

	public static var level2(default,never):Level = {
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

	// Playable level list
	public static var levels(default,never) = [
		{level:level1, name:"Level 1"},
		{level:level2, name:"Level 2"}
	];

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
}