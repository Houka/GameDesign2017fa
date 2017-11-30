package;

import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.ui.FlxBar; 
import flixel.system.FlxSound;
import openfl.Assets;
using StringTools;

typedef Level = {
	var mapFilepath:String;
	var tilemap:String;
	var startHealth:Int;
	var waves:Array<Array<Int>>;
	var buttonTypes:Array<Int>;
	var buildLimit:Int;
}

class LevelData{
	public static var level1:Level = {
		mapFilepath:"assets/maps/level1.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0,0,0],
				[0,0,0,0,1]],
		buttonTypes:[0],
		buildLimit:1
	}
	
	public static var level2:Level = {
		mapFilepath:"assets/maps/level2.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:3,
		waves:[[0,0,0],
				[0,0,0],
				[0, 0,0,1]],
		buttonTypes:[0,3],
		buildLimit:1
	}
	
	public static var level3:Level = {
		mapFilepath:"assets/maps/level3.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1],
				[1, 1],
				[0, 1, 0, 1, 0],
				[1,1,0,0]],
		buttonTypes:[0, 1,3],
		buildLimit:2
	}
	
	public static var level4:Level = {
		mapFilepath:"assets/maps/level4.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1,1,1,1,1],
				[0, 1, 1, 0],
				[1, 1, 1, 1, 0,0,0,0],
				[0,0,0,1,1,1,0,0]],
		buttonTypes:[0, 1, 3],
		buildLimit:2
	}
	
	public static var level5:Level = {
		mapFilepath:"assets/maps/level5.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1],
				[0, 1, 2, 1, 0],
				[1, 1, 1, 1, 2, 2, 2],
				[2,2,0,0,1,2]],
		buttonTypes:[0, 1,2, 3],
		buildLimit:2
	}
	
	public static var level6:Level = {
		mapFilepath:"assets/maps/level6.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0],
				[0, 0, 0,0,0],
				[0, 1, 0, 1, 0],
				[0, 0, 0, 1, 1,1],
				[1, 1, 1, 1, 1, 1, 2, 2],
				[2, 2, 1, 2, 1, 1, 2],
				[2,2,2,2,2,2,2]],
		buttonTypes:[0, 1,2, 3,4],
		buildLimit:2
	}
	
	public static var level7:Level = {
		mapFilepath:"assets/maps/level7.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1,1,1],
				[1, 1, 1,2,2],
				[0, 1, 0,2,2,2],
				[1, 1,1,1,2,2]],
		buttonTypes:[0, 1,2, 3,4,5],
		buildLimit:2
	}
	
	public static var level8:Level = {
		mapFilepath:"assets/maps/level8.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1],
				[0, 1,2, 0]],
		buttonTypes:[0, 1,2, 3,4],
		buildLimit:3
	}
	
	public static var level9:Level = {
		mapFilepath:"assets/maps/level9.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1],
				[0, 1, 0],
				[1, 1, 1]],
		buttonTypes:[0, 1,2, 3,4],
		buildLimit:3
	}
	
	public static var level10:Level = {
		mapFilepath:"assets/maps/level10.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1],
				[0, 1, 0],
				[1, 1]],
		buttonTypes:[0, 1,2, 3,4],
		buildLimit:3
	}
 
	public static var level11:Level = {
		mapFilepath:"assets/maps/level11.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1,1,1],
				[1, 1, 1,2,2],
				[0, 1, 0,2,2,2],
				[1, 1,1,1]],
		buttonTypes:[0, 1,2, 3,4,5],
		buildLimit:3
	}
	
	public static var level12:Level = {
		mapFilepath:"assets/maps/level12.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0],
				[1],
				[0,1],
				[1,1],
				[0, 0, 1, 1],
				[1],
				[0, 0],
				[2],
				[1, 0, 2],
				[2, 2],
				[1, 1, 2],
				[1, 2, 1, 2, 1],
				[2,2,2,2,0,0]],
		buttonTypes:[0, 1,2, 3,4,5],
		buildLimit:3
	}
	
	public static var level13:Level = {
		mapFilepath:"assets/maps/level13.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0],
				[1],
				[0,1],
				[1,1],
				[0, 0, 1, 1],
				[1],
				[0, 0,0],
				[2],
				[1, 0, 2],
				[2, 2,1],
				[1, 1, 2],
				[1, 2, 1, 2, 1],
				[2,2,2,2,0,0]],
		buttonTypes:[0, 1,2, 3,4,5],
		buildLimit:3
	}

	public static var levels = [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, level11, level12, level13];
	public static var currentLevel = 0;
	public static var maxLevelReached = currentLevel;
	public static function getCurrentLevel():Null<Level>{
		if (currentLevel>=levels.length){
			trace("Error: Level "+currentLevel+" does not exists");
			currentLevel = 0;
			return null;
		}
		
		return levels[currentLevel];
	}
	public static function gotoNextLevel():Null<Level>{
		currentLevel ++;
		maxLevelReached = Std.int(Math.max(currentLevel, maxLevelReached));
		if(maxLevelReached == 1){
			maxLevelReached = 2;
		}
		return getCurrentLevel();
	}
}