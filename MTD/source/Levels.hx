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
	var waves: Array<Array<Int>>;	// each int represents an enemy type starting from index 0. 
									// each row in the 2d array is a wave
									// each wave spawns the cooresponding enemy type in order
	@:optional var isTutorial: Bool; 
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
		defaultTowerPrice: 8,
		waves:[]
	}

	//LEVEL 0 IS TUTORIAL LEVEL
	public static var level0(default,never):Level = {
		map:"assets/maps/level1.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 1, 
		isTutorial: true, 
		waves:[]
		//buttonsAvail: 0
	}

	public static var level1(default,never):Level = {
		map:"assets/maps/level1.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8,
		waves:[
			[0],
			[0,0],
			[0,0,0]
		]
	}

	public static var level2(default,never):Level = {
		map:"assets/maps/level2.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8,
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	public static var level3(default,never):Level = {
		map:"assets/maps/level3.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8, 
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	public static var level4(default,never):Level = {
		map:"assets/maps/level4.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 2,
		defaultTowerPrice: 8, 
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	public static var level5(default,never):Level = {
		map:"assets/maps/level5.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8, 
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	public static var level6(default,never):Level = {
		map:"assets/maps/level6.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8, 
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	public static var level7(default,never):Level = {
		map:"assets/maps/level7.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8, 
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	public static var level8(default,never):Level = {
		map:"assets/maps/level8.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8, 
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	public static var level9(default,never):Level = {
		map:"assets/maps/level9.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8, 
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	public static var level10(default,never):Level = {
		map:"assets/maps/level10.csv",
		mapWidth: 15,
		mapHeight:11,
		tilemap:"assets/tiles/auto_tilemap.png",
		start: toCameraCoordinates(5,0),
		goal: toCameraCoordinates(7,9),
		health: 9,
		money: 50,
		defaultTowerPrice: 8, 
		waves:[
			[0,0,0,0,0],
			[1,1,1,1,1]
		]
	}

	// Playable level list
	public static var levels(default,never) = [
		{level:level0, name:"Level 0"},
		{level:level1, name:"Level 1"},
		{level:level2, name:"Level 2"}, 
		{level:level3, name:"Level 3"}, 
		{level:level4, name:"Level 4"}, 
		{level:level5, name:"Level 5"}, 
		{level:level6, name:"Level 6"}, 
		{level:level7, name:"Level 7"}, 
		{level:level8, name:"Level 8"}, 
		{level:level9, name:"Level 9"}, 
		{level:level10, name:"Level 10"}
	];

	public static var currentLevel:Int = -1;

	public static function loadMap(lvl:Level, ?IsAuto:Bool = false):FlxTilemap{
		// set current level
		for (i in 0...levels.length){
			if (lvl == levels[i].level)
				currentLevel = i;
		}

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