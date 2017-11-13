package gameStates;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import controllers.CollisionController;
import ui.InGameMenu;
import ui.HUD;
import utils.Button;
import gameObjects.*;
import Constants;
import Levels;
import Logging;
import AssetPaths;
import Type;
import flixel.addons.text.FlxTypeText; 
import flixel.math.FlxRect; 
using flixel.util.FlxSpriteUtil;


class PlayState extends FlxState
{
	// Public variables
	public var enemiesToKill:Int = 0;
	public var wave:Int = 0;
	public static var isTutorial:Bool = false; 
	public static var tutEnabledButtons: Array<Int> = [];
	private var enemiesToSpawn:Array<Int> = [];
	
	// Game Object groups
	public var collisionController:CollisionController;

	// Tower building objects
	public var towerBlocks:Array<TowerBlock>; 
	//public var _selectedAmmo:Ammo;
	private var _towerBlocks:FlxTypedGroup<TowerBlock>; 
	private var _currTowerStartIndex: Int; 

	// HUD/Menu Groups
	private var inGameMenu:InGameMenu;
	private var _gui:FlxGroup;
	private var _sellMenu:FlxGroup;
	private var _sellConfirm:FlxGroup;
	
	// Text
	private var _centerText:FlxText;

	// Buttons
	private var _nextWaveButton:Button;
	private var _towerButton:Button;
	
	// Other objects
	private var _map:FlxTilemap;
	private var _layerNum:Int; 
	
	// Private variables
	private var _gameOver:Bool = false;
	private var _spawnCounter:Int = 0;
	private var _spawnInterval:Int = 1;
	private var _waveCounter:Int = 0;
	
	private var _enemySpawnPosition:FlxPoint;
	private var _goalPosition:FlxPoint;

	// level specific variables
	private var _level:Level;
	private var _possiblePaths:Array<Array<FlxPoint>>;
	private var _speed:Int = 100; // the base _speed that each enemy starts with
	public var selectedAmmoType = {type:0, price:0};

	//  tutorial specific variables
	private var canvas = new FlxSprite();
	private var _startEnemySpawn: Bool = false; 
	private var overlay = new FlxSprite();
	private var enemyReleased:Int = 0; 
	private var flashOutline = new FlxSprite(); 
	private var secondSquare = new FlxSprite(); 

	// variables for tracking stats
	private var _towersKilled:Int = 0;
	
	private var lineStyle:LineStyle = { color: FlxColor.BLACK, thickness: 1 };
	private var drawStyle:DrawStyle = { smoothing: true };

	private var _tutStateTracker:Int = 1; 
	private var _tutText: FlxTypeText = new FlxTypeText(0, 250, FlxG.width, "", 30);

	public function new(level:Level){
		super();
		_level = level;
	}
	
	/**
	 * Create a new playable game state.
	 */
	override public function create():Void
	{
		Constants.PS = this;

		// Constants.playMusic("bg_music");
		
		FlxG.timeScale = 1;
		
		// Create map
		
		_map = Levels.loadMap(_level, true);
		_enemySpawnPosition = _level.start;
		_goalPosition = _level.goal;
		_possiblePaths = new Array<Array<FlxPoint>>();
		addPath(_map.findPath(_enemySpawnPosition, _goalPosition.copyTo()));
		
		// Add groups

		collisionController = new CollisionController(_goalPosition);
		_towerBlocks = collisionController.towerBlocks;
		towerBlocks = new Array<TowerBlock>();
		
		// Set up bottom default GUI
		
		inGameMenu = new InGameMenu(nextWaveCallback, sellConfirmCallback);
		_gui = inGameMenu.defaultMenu;
		_sellMenu = inGameMenu.sellMenu; // Set up the sell mode display
		_sellConfirm = inGameMenu.sellConfirmMenu; // Set up the sell confirmation display
		_nextWaveButton = inGameMenu._nextWaveButton;
		_towerButton = inGameMenu._towerButton;

		// Set up HUD GUI

		HUD.init(_level,loseGame,function() {});
		
		// Set up miscellaneous items: center text
		
		_centerText = new FlxText( -200, FlxG.height / 2 - 20, FlxG.width, "", 16);
		_centerText.alignment = CENTER;
		_centerText.borderStyle = SHADOW;

		_layerNum = 0;
		_currTowerStartIndex = 0;
		
		// Add everything to the state
		
		add(_map);
		add(inGameMenu);
		collisionController.addToState(this);
		add(HUD.hud);
		add(_centerText);

		// Log that a new level has started
		Logging.recordLevelStart(cast(Levels.currentLevel,Float));

		// Call this to set up for first wave
		
		killedWave();


		if (_level.isTutorial) {
			HUD.money = 50;
			overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true); 
			overlay.alpha = 0.8; 
			add(overlay);
			//turn on and off overlay? or make it smaller according to what part you're talking about?

			_tutText.alignment = "center";
			add(_tutText);
			_tutText.resetText("Welcome to permafrost. \n \n \nPlease click anywhere to continue.");
			_tutText.start();
			isTutorial = true;
			tutEnabledButtons = [];


			//TODO: Fix this so it doesn't need extra canvas variable
			//not sure if this is useful or not, but red square built on this 
			canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
			add(canvas);
			secondSquare.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
			add(canvas);

			flashOutline.loadGraphic(AssetPaths.tutorialBox__png, true, 50, 50);
		}
		
		// This is a good place to put watch statements during development.
		#if debug
		//FlxG.watch.add( _sellMenu, "visible" );
		#end
	}
	
	/**
	 * Called before each wave to set up _waveCounter and some UI elements.
	 */
	public function killedWave():Void
	{
		if (wave != 0)
			Constants.play("wave_defeated");
		
		_waveCounter = 3 * FlxG.updateFramerate;
		
		_nextWaveButton.visible = true;
		HUD.hud.enemyText.visible = false;
	}
	
	override public function update(elapsed:Float):Void
	{
		// Update enemies left indicator
		// var clickedTower = collisionController.overlapsTower(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y));
		// if (clickedTower != null ) {
		// 	trace(clickedTower.children);
		// }
		// Update collisionController.enemies left indicator
		
		HUD.hud.enemyText.text = "enemies left: " + enemiesToKill;
		
		// Check for key presses, which can substitute for button clicks.
		
		if (FlxG.keys.justReleased.ESCAPE)
		{
			FlxG.sound.destroy(true);
			FlxG.switchState(new MenuState());
		}
		if (FlxG.keys.justReleased.Y) sellConfirmCallback(true);
		if (FlxG.keys.justReleased.N)
		{
			if (_sellConfirm.visible)
				sellConfirmCallback(false);
			else
				nextWaveCallback(true); 
		}
		if (FlxG.keys.anyJustPressed([P])) openSubState(new PauseState());

		// Mouse updates, right just for logging
		if(FlxG.mouse.justReleased && !_gameOver){
			var logString = Date.now()+" Level:"+Levels.currentLevel+" x:"+FlxG.mouse.x+" y:"+FlxG.mouse.y;
			Logging.recordEvent(cast(Constants.LogEvent.MOUSE_RELEASE,UInt), logString);
		}
		if(FlxG.mouse.justPressed && !_gameOver){
			var logString = Date.now()+" Level:"+Levels.currentLevel+" x:"+FlxG.mouse.x+" y:"+FlxG.mouse.y;
			Logging.recordEvent(cast(Constants.LogEvent.MOUSE_PRESS,UInt), logString);
		}

		// collision controller updates

		collisionController.update(elapsed);
		if (!_level.isTutorial) {
			if (FlxG.mouse.justReleased)
			{
				if (inGameMenu.removingMode) {
					popMaterial(); 
					inGameMenu.removingMode = false; 
				}

				else if (inGameMenu.placingMode) {
					buildTower();
					inGameMenu._towerRange.visible = true;
				}

				else if (inGameMenu.buyingMode) {
					inGameMenu._towerRange.visible = false; 
					if (InGameMenu.currItem < 3) {
						buildGunBase(InGameMenu.currItem);  
						InGameMenu.currItem = -1; 
					}
					else if (InGameMenu.currItem >= 3 && InGameMenu.currItem < 6) {
						buildFoundation(InGameMenu.currItem);
						InGameMenu.currItem = -1; 
					}
					inGameMenu.buyingMode != inGameMenu.buyingMode; 
				}

				else
				{
					var selectedTower:Bool = false;
					
					// If the user clicked on a tower, they get the upgrade menu, or the sell menu
					var clickedTower = collisionController.overlapsTower(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y));
					if (clickedTower != null){
						InGameMenu.towerSelected = clickedTower;
							
						if (_sellMenu.visible || _sellConfirm.visible)
							inGameMenu.toggleMenus(ConfirmSell);
						else
							inGameMenu.toggleMenus(Upgrade);
						
						selectedTower = true;
					}
					
					// If the user didn't click on any towers, we go back to the general menu
					
					if (!selectedTower && FlxG.mouse.y < FlxG.height - 20)
					{
						inGameMenu.toggleMenus(General);
					}
				}
			}

			// win game

			if (enemiesToKill == 0 && wave >= _level.waves.length && !_gameOver)
				winGame();
			
			// Controls wave spawning, enemy spawning, 
			
			if (enemiesToKill == 0 && collisionController.towers.length > 0)
			{
				_waveCounter -= Std.int(FlxG.timeScale);
				_nextWaveButton.text = "[N]ext Wave in " + Math.ceil(_waveCounter / FlxG.updateFramerate);
				
				if (_waveCounter <= 0)
				{
					spawnWave();
				}
			}
			else
			{
				_spawnCounter += Std.int(FlxG.timeScale);
				
				if (_spawnCounter > _spawnInterval * FlxG.updateFramerate && enemiesToSpawn.length > 0)
				{
					spawnEnemy();
				}
			}
	  	}
    
	    else {
	      tutorialUpdate(); 
	    }
			
		super.update(elapsed);
	} // End update

	public function removeTower(tower:Tower, killedByEnemy:Bool):Void{
		if(killedByEnemy){
			_towersKilled++;
		}

		collisionController.towers.remove(tower, true);
		_map.setTile(Std.int(tower.x / Constants.TILE_SIZE), Std.int(tower.y / Constants.TILE_SIZE), 0, false);
		
		// Remove the indicator for this tower as well
		for (indicator in collisionController.towerIndicators)
		{
			if (indicator.getMidpoint().x ==  tower.getMidpoint().x && indicator.getMidpoint().y ==  tower.getMidpoint().y)
			{
				collisionController.towerIndicators.remove(indicator, true);
				indicator.visible = false;
				indicator = null;
			}
		}

		for (c in tower.children) {
			_towerBlocks.remove(c);
		}
		// Remove the radius sprite as well and reset the menu if the selected tower was just destroyed
		if (InGameMenu.towerSelected  != null && InGameMenu.towerSelected == tower)
			inGameMenu.toggleMenus(General);
	}
	
	private function sellConfirmCallback(Sure:Bool):Void
	{
		if (!inGameMenu.sellConfirmMenu.visible)
			return;
		
		inGameMenu._towerRange.visible = false;
		
		if (Sure)
		{
			InGameMenu.towerSelected.visible = false;

			removeTower(InGameMenu.towerSelected, false);
			
			// If there are no towers, having the tutorial text and sell button is a bit superfluous
			if (collisionController.towers.countLiving() == -1 && collisionController.towers.countDead() == -1)
			{
				inGameMenu.soldLastTower();
			}
			
			// Give the player their money back
			HUD.money += InGameMenu.towerSelected.value;
			
			// Revert the next tower price
			inGameMenu.towerPrice = Math.ceil(inGameMenu.towerPrice / 1.3);
			
			// Null out the removed tower
			InGameMenu.towerSelected = null;
			
			// Go back to the general menu
			inGameMenu.toggleMenus(General);
		}
		else
		{
			inGameMenu.toggleMenus(General);
		}
	}
	
	/**
	 * A function that is called when the user selects to call the next wave.
	 */
	private function nextWaveCallback(Skip:Bool = false):Void
	{
		if (!_gui.visible && !Skip)
			return;
		
		if (enemiesToKill > 0)
			return;
		
		spawnWave();
		Constants.playSelectSound();
	}
	
	/**
	 * A function that is called when the user elects to restart, which is only possible after losing.
	 */
	private function resetCallback(Skip:Bool = false):Void
	{
		if (!_gui.visible && !Skip)
			return;
		
		FlxG.resetState();
		Constants.playSelectSound();
	}
	
	/**
	 * A function that attempts to build a tower when the user clicks on the playable space. Must have money,
	 * and be building in a valid place (not on another tower, the road, or the GUI).
	 */
	private function buildTower():Void
	{
		if(_gameOver){
			return;
		}
		// Can't place towers on GUI
		if (FlxG.mouse.y > FlxG.height - 16)
		{
			return;
		}
		
		// Can't buy towers without money
		if (HUD.money < inGameMenu.towerPrice)
		{
			Constants.play("deny");
			
			inGameMenu.toggleMenus(General);
			return;
		}
		
		// Snap to grid
		var xPos:Float = (FlxG.mouse.x - (FlxG.mouse.x % Constants.TILE_SIZE));
		var yPos:Float = (FlxG.mouse.y - (FlxG.mouse.y % Constants.TILE_SIZE));
		
		// Can't place towers on other towers
		for (tower in collisionController.towers)
		{
			if (tower.x == xPos && tower.y == yPos)
			{
				Constants.play("deny");
				
				inGameMenu.toggleMenus(General);
				return;
			}
		}
		
		// Can't place towers off the road
		if (_map.getTile(Std.int(xPos / Constants.TILE_SIZE), Std.int(yPos / Constants.TILE_SIZE)) != 0)
		{
			Constants.play("deny");
			
			inGameMenu.toggleMenus(General);
			return;
		}
		
		var tower: Tower = new Tower(xPos, yPos, inGameMenu.towerPrice, towerBlocks, selectedAmmoType.type);
		collisionController.towers.add(tower);
		var level = 0; 
		for (t in towerBlocks.slice(_currTowerStartIndex)) {
			var xpos = tower.getMidpoint().x - t.origin.x;
            var ypos = tower.getMidpoint().y-level*Constants.HEIGHT_OFFSET - t.origin.y;
            level++;
            t.setPosition(xpos,ypos);
		}

		_map.setTile(Std.int(xPos / Constants.TILE_SIZE), Std.int(yPos / Constants.TILE_SIZE), 1, false);
		
		inGameMenu.builtFirstTower();
		
		Constants.play("build");
		
		HUD.money -= inGameMenu.towerPrice;
		inGameMenu.towerPrice += Std.int(inGameMenu.towerPrice * 0.3);
		_towerButton.text = "Buy [T]ower ($" + inGameMenu.towerPrice + ")";
		inGameMenu.toggleMenus(General);

		//Reset everything for next building iteration
		inGameMenu.placingMode = false;
		_layerNum = 0; 
		_currTowerStartIndex = towerBlocks.length; 

		//Log tower built
		var logString = Date.now()+" Level:"+Levels.currentLevel+" x:"+xPos+" y:"+yPos+" Materials:"+tower.toString();
		Logging.recordEvent(cast(Constants.LogEvent.TOWER_BUILD,UInt), logString);
	}

	/** A function that adds a new gunbase and then iterates the number of layers in the tower. **/
	private function buildGunBase(ItemNum: Int): Void { 
		var gunAssets: Array<String> = [AssetPaths.snowman_head__png, AssetPaths.snowman_spray__png, AssetPaths.snowman_machine_gun__png];
		addMaterial(new GunBase(FlxG.width-180, 500-_layerNum*(Constants.HEIGHT_OFFSET+5), gunAssets[ItemNum])); 
		_layerNum++;
	}

	/** A function that adds a new foundation and then iterates the number of layers in the tower. **/
	private function buildFoundation(ItemNum: Int): Void { 
		var foundAssets: Array<String> = [AssetPaths.snow1__png, AssetPaths.snowman_ice__png, AssetPaths.snowman_coal__png];

		addMaterial(new Foundation(FlxG.width-180, 500-_layerNum*Constants.HEIGHT_OFFSET, ItemNum, foundAssets[ItemNum - 3])); 
		_layerNum++; 
	}

	/** A function that adds a gunBase or foundation to the towerBlocks list. **/
	private function addMaterial(obj:TowerBlock):Void{
        towerBlocks.push(obj);
        _towerBlocks.add(obj);
    }

    private function popMaterial():TowerBlock {
    	var obj = towerBlocks.pop(); 
    	if (obj != null) {
    		_towerBlocks.remove(obj);
    	}
    	return obj; 
    }

	
	/**
	 * Used to display either the wave number or Game Over message via the animated fly-in, fly-out text.
	 * 
	 * @param	End		Whether or not this is the end of the game. If true, message will say "Game Over! :("
	 */
	private function announceWave(End:Bool = false, ?gameOverText:String):Void
	{
		_centerText.x = -200;
		_centerText.text = "Wave " + wave;
		
		if (End)
			_centerText.text = gameOverText;
		
		FlxTween.tween(_centerText, { x: 0 }, 2, { ease: FlxEase.expoOut, onComplete: hideText });
		
		HUD.hud.waveText.text = "Wave: " + wave;
		HUD.hud.waveText.size = 16;
		HUD.hud.waveText.visible = true;
	}
	
	/**
	 * Hides the center text message display on announceWave, once the first tween is complete.
	 */
	private function hideText(Tween:FlxTween):Void
	{
		FlxTween.tween(_centerText, { x: FlxG.width }, 2, { ease: FlxEase.expoIn });
		if (_gameOver && wave >= _level.waves.length && enemiesToSpawn.length <= 0 && enemiesToKill <= 0 && HUD.health > 0)
			openSubState(new WinState(_level));
		else if (_gameOver)
			openSubState(new LoseState(_level));
	}
	
	/**
	 * Spawns the next wave. This increments the wave variable, displays the center text message,
	 * sets the number of collisionController.enemies to spawn and kill, hides the next wave button, and shows the
	 * notification of the number of collisionController.enemies.
	 */
	private function spawnWave():Void
	{
		if (_gameOver)
			return;
		
		if (wave >= _level.waves.length)
			return;

		wave++;
		announceWave();
		enemiesToSpawn = _level.waves[wave-1].copy();
		enemiesToKill = enemiesToSpawn.length;
		
		_nextWaveButton.visible = false;
		
		HUD.hud.enemyText.visible = true;
		HUD.hud.enemyText.size = Constants.HUD_TEXT_SIZE;

		var logString = Date.now()+" Level:"+Levels.currentLevel+" Money:"+HUD.money+
			" Wave:"+wave+" Towers Killed:"+_towersKilled;
		Logging.recordEvent(cast(Constants.LogEvent.WAVE_START, UInt), logString);
	}
	
	/**
	 * Spawns an enemy. Decrements the enemiesToSpawn variable, and recycles an enemy from collisionController.enemies and then initiates
	 * it and gives it a path to follow.
	 */
	private function spawnEnemy():Void
	{
		var type = enemiesToSpawn.shift();
		
		var enemy = collisionController.enemies.recycle(Enemy.new.bind(0, 0, 0));
		enemy.init(_enemySpawnPosition.x, _enemySpawnPosition.y - 12, type);

		//	try to get path to goal (considering towers). 
		//  If there is no path then default to shortest path without considering towers

		var path = _map.findPath(_enemySpawnPosition, _goalPosition.copyTo());
		if (path == null){
			// copy the default path in
			path = getPath(0);
		}

		enemy.followPath(path, _speed + wave);
		_spawnCounter = 0;
	}

	/**
	 * Called when you win. Of course!
	 */
	private function winGame():Void
	{
		Logging.recordLevelEnd();

		_gameOver = true;
		
		collisionController.kill();
		inGameMenu.kill();
		
		announceWave(true,"You Win! :)");
		
		_towerButton.text = "[R]estart";
		_towerButton.onDown.callback = resetCallback.bind(false);
		
		Constants.play("game_over");
	}
	
	/**
	 * Called when you lose. Of course!
	 */
	private function loseGame():Void
	{
		//Log Game Over
		var logString = "Wave num:"+wave+" Level:"+Levels.currentLevel;
		Logging.recordEvent(cast(Constants.LogEvent.GAME_OVER, UInt), logString);
		Logging.recordLevelEnd();

		_gameOver = true;
		
		collisionController.kill();
		inGameMenu.kill();
		
		announceWave(true,"Game Over! :(");
		
		_towerButton.text = "[R]estart";
		_towerButton.onDown.callback = resetCallback.bind(false);
		
		Constants.play("game_over");
	}

	private function getPath(index:Int):Array<FlxPoint>{
		var path:Array<FlxPoint>;
		var tempPoint:FlxPoint;
		path = [];
		for (i in _possiblePaths[index]){
			tempPoint = new FlxPoint(i.x,i.y);
			path.push(tempPoint);
		}

		return path;
	}

	private function addPath(Value:Array<FlxPoint>):Array<FlxPoint>{
		var path = new Array<FlxPoint>();

		var tempPoint:FlxPoint;
		for (i in Value){
			tempPoint = new FlxPoint(i.x,i.y);
			path.push(tempPoint);
		}

		_possiblePaths.push(path);
		return path;
	}

	private function tutorialUpdate(): Void { 
		var _tutTextList: Array<String> = ["Welcome to Permafrost. \nClick anywhere to continue.", 
											"Your job is to stop the greedy \nkids from getting to the \nNorth Pole. 
											\n\nStart by building your first \nSnowman Defense Turret.", 
											"Great! Now click build!", 
											"Place your tower on the map. \n\nClick on your tower to check \nits health and attack.", 
											"Placing your tower will start \nthe first wave of pesky kids.", 
											"Well done! \n\n\nWe are going to need a \nstronger tower for wave 2. 
											\n\nAdd more snow \nto increase health.", 
											"", 
											"Now add a Snowman Turret.", 
											"You can also give your \nSnowman Turret different \nammo that will change its \nattack style. 
											\n\n\nEach snowman turret in a \ntower can have an ammo type.", 
											"Now build your upgraded tower \nand good luck!", 
											"", "", "", ""];

		if (_tutStateTracker == 1) {
			tutEnabledButtons.push(0);
			//check to see if they click on gunbase 1 
			if (InGameMenu.currItem == 0) {
				buildGunBase(InGameMenu.currItem); 
				_tutStateTracker+= 1; 
			}
		}

		if (_tutStateTracker == 2) {
			//check to see if they click on build 
			if (inGameMenu.placingMode) {
				//if so, create highlight square on path
				canvas.drawRect(320, 380, 64, 64, FlxColor.RED, lineStyle, drawStyle);
				canvas.flicker(0, 0.5); 
				_tutStateTracker += 1; 
			}
		}

		if (_tutStateTracker == 3) {
			//check to see if they clicked on highlighted square
			if (FlxG.mouse.x >= 319 && FlxG.mouse.x <= 383 && FlxG.mouse.y >= 379 && FlxG.mouse.y <= 443) {
				//remove red square 
				canvas.kill();
				//place gunbase on the square
				buildTower();
				_tutStateTracker += 1; 
			}
		}

		if (_tutStateTracker == 4) {
			if (enemyReleased == 5) {
				_tutStateTracker += 1;
			}
		}

		if (_tutStateTracker == 5) {
			HUD.money = 50; 
			_tutText.resetText(_tutTextList[_tutStateTracker]);
			_tutText.start();
			_tutStateTracker += 1; 
		}

		if (_tutStateTracker == 6) {
			tutEnabledButtons.push(3);
			overlay.y = 0; 
			_tutText.y = 150; 
			//check if they click on snow foundation
			if (InGameMenu.currItem == 3) {
				buildFoundation(InGameMenu.currItem); 
				_tutStateTracker += 1; 
			}
		}

		if (_tutStateTracker == 7) {
			//check if they click on the first gunbase
			if (InGameMenu.currItem == 0) {
				buildGunBase(InGameMenu.currItem); 
				_tutStateTracker += 1; 
			}
		}

		//Select ammo
		if (_tutStateTracker == 8) {
			tutEnabledButtons.push(6);
			if (InGameMenu.currItem == 6) {
				Constants.PS.selectedAmmoType = {type:0, price:12};
				enemyReleased = 0;
				_tutStateTracker += 1;
			}
		}

		//Click build
		if (_tutStateTracker == 9) {
			//check to see if they click on build 
			if (inGameMenu.placingMode) {
				canvas.revive();
				_tutStateTracker += 1; 
			}
		}

		//Check that tower is placed on path 
		if (_tutStateTracker == 10) {
			if (FlxG.mouse.x >= 319 && FlxG.mouse.x <= 383 && FlxG.mouse.y >= 379 && FlxG.mouse.y <= 443) {
				//remove red square 
				canvas.kill(); 
				//place gunbase on the square
				buildTower();
				_tutStateTracker += 1; 
			}
		}

		if (_tutStateTracker == 11) {
			if (enemiesToKill == 0 && enemyReleased == 10) {
				_tutStateTracker += 1; 
			}
		}

		if (_tutStateTracker == 12) {
			winGame(); 
		}


		if (FlxG.mouse.justReleased) {
			_tutText.resetText(_tutTextList[_tutStateTracker]);
			_tutText.start();

			if (_tutStateTracker == 0) {
				_tutStateTracker+= 1; 
			}

			if (_tutStateTracker == 1) {
				flashOutline.x = FlxG.width - 260;
				flashOutline.y = 155;
				add(flashOutline);
				flashOutline.flicker(0, 0.5);
				overlay.x = -165; 
				overlay.y = 0;
				overlay.setGraphicSize(FlxG.width-315, FlxG.height);
				_tutText.x = -170;
			}

			if (_tutStateTracker == 2) {
				flashOutline.kill();
				_tutText.x = -180;
				_tutText.y = 300;
			}

			if (_tutStateTracker == 3) {
				_tutText.x = -160;
				_tutText.y = 100; 
				overlay.y = -350;
				overlay.height = 50;
			}


			if (_tutStateTracker == 4) {
				overlay.y = 500; 
				_tutText.y = 550;
				enemiesToSpawn = [0, 0, 0, 0, 0]; 
				//MAKE SURE TO ALSO SHOW HEALTH AND STATS 
				while (enemiesToSpawn.length > 0) {
				// if (collisionController.towers.length == 1 && !enemyReleased) {
					//release single kid 
					spawnEnemy(); 
					enemyReleased += 1;
				}
			} 

			if (_tutStateTracker == 7) {
				enemyReleased = 0; 
				_tutText.y = 300;
				flashOutline.revive(); 
				flashOutline.x = FlxG.width - 260;
				flashOutline.y = 150;
				// add(flashOutline);
				flashOutline.flicker(0, 0.5);

				for (tower in collisionController.towers)
				{
					removeTower(tower, false);
			
				}
			}

			if (_tutStateTracker == 8) {
				flashOutline.y = 310; 
				_tutText.y = 150;
				_tutText.x = -180; 

			}

			if (_tutStateTracker == 9) {
				flashOutline.kill();
				_tutText.x = -160;
			}
			if (_tutStateTracker == 10) {
				overlay.kill();
			}
			if (_tutStateTracker == 11) {
				enemiesToSpawn = [0, 0, 0, 0, 0, 1, 1, 1, 1, 1]; 
				enemiesToKill = 10; 
				//MAKE SURE TO ALSO SHOW HEALTH AND STATS 
				while (enemiesToSpawn.length > 0 && enemiesToKill > 0) {
					spawnEnemy(); 
					enemyReleased += 1;
				}

			}
		}
	}

	private function setOverlay():Void {
		overlay.setGraphicSize(FlxG.width-600, FlxG.height);
	}
}
