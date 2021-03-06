package gameStates;

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
import flixel.util.FlxTimer; 
import flixel.math.FlxMath; 
import flixel.input.mouse.FlxMouseEventManager;
import openfl.Assets;
using StringTools;

import Logging;
import LevelData;
import gameObjects.*;
import gameObjects.Bullet;
import controllers.CollisionController;
import utils.*;
import GameObjectFactory;

class GameState extends FlxState{
	public static var tutorialEvent:Int = 0;
	public static var tutorialArrow:FlxSprite;

	private var _level:Level;
	private var map:FlxTilemap;
	private var enemies:FlxTypedGroup<Enemy>;
	private var spawns:FlxTypedGroup<SpawnArea>;
	private var homebase:Homebase;
	private var player:Player;
	private var collisionController:CollisionController;
	public var healthBars = new FlxTypedGroup<FlxBar>();
	private var _centerText:FlxText;
	private var wavesRemaining:FlxText;
	private var enemiesRemaining:FlxText;
	private var paused = false;
	private var waveAnnounced = false; 
	private var timeLeft: Float = 3;
	private var timerText: Int = 0;  

	public static var towersKilled = 0;
	public var totalWaves:Int;
	public var enemiesLeft:Int;
	public var startSpawn:Bool;

	public static var abTestVersion = Logging.assignABTestValue(FlxG.random.int(1,2));
	public static var isATesting = true;

	override public function create(){
		super.create();

        FlxG.cameras.bgColor = FlxColor.fromInt(0xff85bbff);

		FlxG.timeScale = 1;
		if (isATesting)
			persistentUpdate = true;

		// init flx group vars
		var towers = new FlxTypedGroup<Tower>();
		var towerLayers = new FlxTypedGroup<FlxSprite>();
		this.enemies = new FlxTypedGroup<Enemy>();
		var bullets = new FlxTypedGroup<Bullet>();
		var allies = new FlxTypedGroup<Ally>();
		spawns = new FlxTypedGroup<SpawnArea>();

		// get level data
		_level = LevelData.getCurrentLevel();
		var mapArray = Util.loadCSV(_level.mapFilepath);

		// log the start of this level
		Logging.recordLevelEnd();
		Logging.recordLevelStart(LevelData.currentLevel);

		// Set up sprite-mouse-interaction for cookie clicker enemies
		// Call this before making enemies
		FlxG.plugins.add(new FlxMouseEventManager());

		// make game objects from level data
		var originalMap = new FlxTilemap();
		var towerMap = new FlxTilemap();
		var mapWidth = mapArray[0].length;
		var mapHeight = mapArray.length;
		for (row in 0...mapHeight){
			for (col in 0...mapWidth){
				switch (mapArray[row][col]) {
					case 0:
						continue;
					case 1:
						continue;
					case 2:
						// create spawn point and then remove it from map
						GameObjectFactory.addSpawnPoint(spawns,col,row,enemies,_level.waves);
						mapArray[row][col] = 0; // remove it
					case 3:
						// create homebase and remove it from map
						homebase = GameObjectFactory.createHomebase(col,row,_level.startHealth);
						mapArray[row][col] = 0; // remove it
					case 4:
						// create player and remove it from map
						player = GameObjectFactory.createPlayer(col,row,allies);
						mapArray[row][col] = 0; //remove it
					case 5:
						// create tower placeholder
						GameObjectFactory.addTower(towers, col, row, bullets, enemies, towerLayers,towerMap);
						mapArray[row][col] = 0; // remove it
					case 6:
						// create ally
						GameObjectFactory.addAlly(allies, col*Util.TILE_SIZE, row*Util.TILE_SIZE);
						mapArray[row][col] = 0; // remove it
					default:
						mapArray[row][col] = 0; // remove it
				}
			}
		}

		// load the map
		originalMap.loadMapFrom2DArray(mapArray, _level.tilemap, Util.TILE_SIZE,Util.TILE_SIZE, AUTO);
		towerMap.loadMapFrom2DArray(Util.copy2DArray(mapArray), _level.tilemap, Util.TILE_SIZE,Util.TILE_SIZE, AUTO);
		this.map = originalMap;

		// set goal for spawn point and pass the map to spawn area
		var goal = homebase.midpoint;
		for (spawnArea in spawns){
			spawnArea.goal = new FlxPoint(goal.x,goal.y);
			spawnArea.map = towerMap;
			spawnArea.computeDefaultPath();
		} 

		// update allies to follow player
		for(a in allies){
			a.target = player;
		}


		// collision setup
		collisionController = new CollisionController(originalMap, towerMap, player, allies, 
								enemies, bullets, towers, homebase, spawns, this);
								
		
		// center text
		_centerText = new FlxText( -200, 80, FlxG.width, "", 32);
		_centerText.alignment = CENTER;
		_centerText.borderStyle = SHADOW;
		_centerText.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);

		// add all objects to screen
		add(originalMap);
		add(towers);
		add(allies);
		add(enemies);
		add(spawns);
		add(bullets);
		add(towerLayers);

		if (player != null)
			add(player);
		else{
			var center = Util.toMapCoordinates(FlxG.width/2, FlxG.height/2);
			player = GameObjectFactory.createPlayer(Std.int(center.x),Std.int(center.y),allies);
			player.exists = false;

			// add dummy worker to each tower if there is no player
			for (t in towers)
				t.addWorker(GameObjectFactory.dummyAlly);
		}
		add(homebase);
		add(_centerText);

		// start music
		Sounds.playBGM("GameLoop",0.4);

		// camera setup
		var LEVEL_MIN_X = 0;
		var LEVEL_MIN_Y = 0;
		var LEVEL_MAX_X = Util.TILE_SIZE*mapWidth;
		var LEVEL_MAX_Y = Util.TILE_SIZE*mapHeight;
		FlxG.cameras.bgColor = FlxColor.fromInt(0xff85bbff);
		FlxG.camera.setScrollBoundsRect(LEVEL_MIN_X, LEVEL_MIN_Y,
			LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true);
		FlxG.camera.follow(player, LOCKON, 0.5);
	
		// tutorial related setup
		GameState.tutorialArrow = new FlxSprite(0,0);
		GameState.tutorialArrow.loadGraphic(AssetPaths.SmallArrow__png, true, 34, 50);
		GameState.tutorialArrow.animation.add("play", [0,1,2,3], 5, true);
		GameState.tutorialArrow.animation.play("play");
		GameState.tutorialArrow.visible = false;
		GameState.tutorialArrow.angle = 90;
		add(GameState.tutorialArrow);
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 0){
			var randomTower = towers.getFirstAlive();
			var tutPos = Util.toMapCoordinates(randomTower.x,randomTower.y);
			tutPos = Util.toCameraCoordinates(Std.int(tutPos.x - 1), Std.int(tutPos.y));
			GameState.tutorialArrow.setPosition(Std.int(tutPos.x)+GameState.tutorialArrow.width/2, 
				Std.int(tutPos.y));
			GameState.tutorialArrow.visible = true;
		}
		
		// pause, exit, restart buttons
		var pauseButton = new FlxButton(870,450,"", pauseCallBack);
        pauseButton.loadGraphic(AssetPaths.pauseButton__png, true, 84, 98);
        add(pauseButton);
		
		var restartButton = new FlxButton(870,540,"", restartCallBack);
        restartButton.loadGraphic(AssetPaths.resetButton__png, true, 84, 98);
        add(restartButton);
		
		var exitButton = new FlxButton(870,630,"", exitCallBack);
        exitButton.loadGraphic(AssetPaths.exitButton__png, true, 84, 98);
        add(exitButton);
		
		
		// enemies remaining and waves left count
		var remaining = new flixel.text.FlxText(615, -35, 0, "Enemies Remaining:", 20);
        remaining.setFormat("assets/fonts/almonte_snow.ttf", 35, FlxColor.fromInt(0xFF508AAD));
		remaining.y += 40;
		add(remaining);
		var remaining2 = new flixel.text.FlxText(645, 5, 0, "Waves Remaining:", 20);
        remaining2.setFormat("assets/fonts/almonte_snow.ttf", 35, FlxColor.fromInt(0xFF508AAD));
		remaining2.y += 40;
		add(remaining2);
		
		enemiesRemaining = new flixel.text.FlxText(910, -35, 0, "0", 20);
        enemiesRemaining.setFormat("assets/fonts/almonte.ttf", 40, FlxColor.fromInt(0xFF508AAD));
		enemiesRemaining.y += 40;
		add(enemiesRemaining);
		
		startSpawn = false;
		totalWaves = spawns.getFirstAlive().wavesLeft;
		wavesRemaining = new flixel.text.FlxText(910, 5, 0, Std.string(totalWaves), 20);
        wavesRemaining.setFormat("assets/fonts/almonte.ttf", 40, FlxColor.fromInt(0xFF508AAD));
		wavesRemaining.y += 40;
		add(wavesRemaining);
	}
	
	override public function update(elapsed:Float){
		super.update(elapsed);

		// keyboard shortcuts
		if (FlxG.keys.anyJustPressed([P, Q])) {
			if (isATesting)
				persistentUpdate = false;
			paused = true;
			openSubState(new PauseState());
		} else if (!paused && !Std.is(subState, PauseState)){
			if (isATesting)
				persistentUpdate = true;
		}

		// log mouse clicks
		if(FlxG.mouse.justReleased){
			var logString = "Level:"+LevelData.currentLevel+" X:"+FlxG.mouse.x+" Y:"+FlxG.mouse.y;
			Logging.recordEvent(2, logString);
		}
		if(FlxG.mouse.justPressed){
			var logString = "Level:"+LevelData.currentLevel+" X:"+FlxG.mouse.x+" Y:"+FlxG.mouse.y;
			Logging.recordEvent(1, logString);
		}

		if (waveAnnounced) { 
			timeLeft -= FlxG.elapsed; 
			timerText = FlxMath.absInt(cast(FlxMath.roundDecimal(timeLeft, 0),Int));
			_centerText.text = "Wave " + (spawns.getFirstAlive().currentWave + 1) + " starts in " + timerText;

			if (timerText == 0) {
				startSpawn = true;
				for (spawnArea in spawns) {
					spawnArea.countdownComplete = true; 
				}
				waveAnnounced = false; 
				timeLeft = 3;
			}
		}

		// update interactions of game objects
		collisionController.update(elapsed);
		
		var waveStart = true;
		var playerReady = true;
		for (spawnArea in spawns){
			if (!spawnArea.waveStart)
				waveStart = false;
			if (!spawnArea.playerReady)
				playerReady = false;
		}

		if (waveStart && playerReady) {
			announceWave();
			for (spawnArea in spawns){
				spawnArea.waveComplete = false;
				spawnArea.waveStart = false;
			}
		}

		add(healthBars);

		if (!player.exists)
			player.update(elapsed);
			
		
		// enemies remaining counter
		if (startSpawn) {
			var enemiesLeft = enemies.countLiving();
			
			if (enemiesLeft < 0)
				enemiesLeft = 0;
		
			enemiesRemaining.destroy();
			enemiesRemaining = new flixel.text.FlxText(910, -38, 0, Std.string(enemiesLeft), 20);
			enemiesRemaining.setFormat("assets/fonts/almonte.ttf", 40, FlxColor.fromInt(0xFF508AAD));
			enemiesRemaining.y += 40;
			add(enemiesRemaining);
		}

		// last thing to do on update
		checkGameOver();
	}
	
	private function pauseCallBack():Void {
		if(Std.is(subState,BuildState) ){
			paused = false;
			return;
		}
		if (isATesting)
			persistentUpdate = false;
		paused = true;
		openSubState(new PauseState());
	}
	
	private function exitCallBack():Void {
		FlxG.switchState(new LevelSelectState());
	}
	
	private function restartCallBack():Void {
		if (LevelData.currentLevel == 0)
			GameState.tutorialEvent = 0;
		FlxG.switchState(new GameState());
	}
	
	/*	
	*	Announces start of new wave.
	*/
	private function announceWave():Void {
		waveAnnounced = true; 
		_centerText.x = -200;

		FlxTween.tween(_centerText, { x: 0 }, 2, { ease: FlxEase.expoOut, onComplete: hideText });

		//Log current wave was beaten
		var logString = "Level:"+LevelData.currentLevel+" Wave:"+spawns.getFirstAlive().currentWave+" Towers Killed:"+towersKilled;
		Logging.recordEvent(4, logString);
		
		// startSpawn = true;
		
		// waves remaining counter		
		wavesRemaining.destroy();
		wavesRemaining = new flixel.text.FlxText(910, 5, 0, Std.string(spawns.getFirstAlive().wavesLeft - 1), 20);
        wavesRemaining.setFormat("assets/fonts/almonte.ttf", 40, FlxColor.fromInt(0xFF508AAD));
		wavesRemaining.y += 40;
		add(wavesRemaining);
	}

	private function hideText(Tween:FlxTween):Void {
		FlxTween.tween(_centerText, { x: FlxG.width }, 2, { ease: FlxEase.expoIn });
	}

	/*  Checks whether or not the game is over.
	*   If it is over then envoke either a win screen or lose screen
	*/
	private function checkGameOver(){
		// if you lost the game then open LoseState, then return
		if (homebase.gameover || !player.alive || homebase.health <= 0){
			var logString = "Wave Num:"+spawns.getFirstAlive().currentWave+" Level:"+LevelData.currentLevel;
			Logging.recordEvent(6, logString);
			if (isATesting)
				persistentUpdate = false;
			Sounds.play("lose",1.0);
			openSubState(new LoseState());
			return;
		}

		// if you won the game then open WinState and record win
		var alive = 0;
		for (e in enemies){
			if (e.alive)
				alive++;
		}
		var gameover = true;
		for (spawnArea in spawns){
			if (!spawnArea.gameover)
				gameover = false;
		}
		if (gameover && alive == 0){
			var logString = "Level:"+LevelData.currentLevel;
			Logging.recordEvent(7, logString);
			Sounds.play("win",0.5);

			if (isATesting)
				persistentUpdate = false;
			
			if (LevelData.currentLevel == 0) {
				if (LevelData.gotoNextLevel() == null)
					FlxG.switchState(new MenuState());
				FlxG.switchState(new GameState());
			}
			else {
				openSubState(new WinState());
			}
		}
	}
}