package;

import flixel.tile.FlxTilemap;
import flixel.math.FlxPoint;
import Constants.TILE_SIZE;

typedef Demo = {
	var map: String; 			// path to csv file for this level
	var mapWidth:Int;
	var mapHeight:Int;
	var tilemap: String;		// path to tilemap for this level
	var start: FlxPoint;
	var goal: FlxPoint;
	var health: Int;			// how much health does homebase have
	var money: Int; 			// starting money
	var defaultTowerPrice: Int;
	var waves: Array<Array<Int>>;	// each int represents an enemy type starting from index 0. 
									// each row in the 2d array is a wave
									// each wave spawns the cooresponding enemy type in order
	@:optional var isTutorial: Bool; 
}

class Levels{
	// Level data
	public static var demo(default,never):Demo = {	// demo level used for menu
		map:"assets/maps/demo.csv",
		mapWidth: 40,
		mapHeight:30,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),					 
		goal: toCameraCoordinates(34,29),
		health: 9,
		money: 50,
		defaultTowerPrice: 8,
		waves:[]
	}

	public static var currentLevel:Int = -1;

	public static function loadMap(lvl:Demo, ?IsAuto:Bool = false):FlxTilemap{

		// load current level's map
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