package gameObjects;

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

import gameStates.LevelSelectState;
import Logging;
import gameStates.MenuState;
import LevelData;
import utils.*;


class SpawnArea extends FlxTypedGroup<FlxSprite>{
	public var midpoint:FlxPoint;
	public var gameover:Bool;
	public var playerReady:Bool;

	public var currentEnemy:Int;
	public var currentWave:Int;
	public var goal:FlxPoint;
	public var map:FlxTilemap;

	private var defaultPath: Array<FlxPoint>;

	private var interval:Int = 1;
	private var counter:Int;
	private var waves:Array<Array<Int>>;
	private var enemies:FlxTypedGroup<Enemy>;
	
	public var waveComplete:Bool;
	public var waveStart:Bool;
	
	public function init(X:Int,Y:Int, enemies:FlxTypedGroup<Enemy>, Waves:Array<Array<Int>>){

		// make 9 forest around spawn point tile
		var forest:FlxSprite;
		for (y in -1...2){
			for (x in -1...2){
				forest = new FlxSprite();
				forest.loadGraphic(AssetPaths.forest__png,false,Util.TILE_SIZE,Util.TILE_SIZE);
				forest.setPosition(X+x*Util.TILE_SIZE,Y+y*Util.TILE_SIZE);
				add(forest);
			}
		}

		// set the mid point of the forest. X and Y are the location of the center forest
		midpoint = new FlxPoint(X,Y);
		gameover = false;
		playerReady = false;

		counter = 0;
		waves = Waves;
		currentWave = 0;
		currentEnemy = 0;
		this.goal = new FlxPoint(X, Y);
		this.map = null; 
		this.enemies = enemies;
		waveComplete = false;
		waveStart = true;

	}
	override public function update(elapsed:Float){
		super.update(elapsed);
		if (gameover || !playerReady)
			return;

		counter += Std.int(FlxG.timeScale);
		if (counter > interval * FlxG.updateFramerate && currentWave < waves.length && waves[currentWave].length > currentEnemy)
		{
			
			var path = map.findPath(midpoint, goal.copyTo());
			if (path == null) {
				path = Util.copyPathFrom(defaultPath, 0); 
			}
			GameObjectFactory.addEnemy(enemies, Std.int(midpoint.x), Std.int(midpoint.y), waves[currentWave][currentEnemy],path);
			counter = 0;
			currentEnemy ++;
			
		}
		else if (currentEnemy >= waves[currentWave].length) {
			if (enemies.countLiving() == 0)
				waveComplete = true;
		}
		
		if (waveComplete && currentWave <= waves.length - 1) {
			currentWave ++;
			currentEnemy = 0;
			waveComplete = false;
			waveStart = true;
		}

		if (currentEnemy >= waves[waves.length-1].length && currentWave >= waves.length - 1)
			gameover = true;
	}

	public function computeDefaultPath(): Void { 
		this.defaultPath = map.findPath(midpoint, goal.copyTo());
	}

}