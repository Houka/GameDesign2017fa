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
import AssetPaths;
import Type;
import flixel.addons.text.FlxTypeText; 
import flixel.math.FlxRect; 
using flixel.util.FlxSpriteUtil;


class PlayState extends FlxState
{
	// Public variables
	public var enemiesToKill:Int = 0;
	public var enemiesToSpawn:Int = 0;
	public var wave:Int = 0;
	public static var isTutorial:Bool = false; 
	
	// Game Object groups
	public var collisionController:CollisionController;
	public var bullets:FlxTypedGroup<Bullet>;
	public var emitters:FlxTypedGroup<EnemyExplosion>;
	public var enemies:FlxTypedGroup<Enemy>;
	public var towerIndicators:FlxTypedGroup<FlxSprite>;
	private var _towers:FlxTypedGroup<Tower>;
	public static var gunBases:FlxTypedGroup<GunBase>; 
	public static var towerBlocks:Array<TowerBlock>; 

	// HUD/Menu Groups
	private var _topGui:FlxGroup;
	
	private var inGameMenu:InGameMenu;
	private var _gui:FlxGroup;
	private var _sellMenu:FlxGroup;
	private var _sellConfirm:FlxGroup;
	
	// Text
	private var _centerText:FlxText;
	private var _enemyText:FlxText;
	private var _waveText:FlxText;

	// Buttons
	private var _nextWaveButton:Button;
	private var _towerButton:Button;
	
	// Other objects
	private var _map:FlxTilemap;
	private var _layerNum:Int; 
	private var _currTowerStartIndex: Int; 
	
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

	//  tutorial specific variables
	private var canvas = new FlxSprite();
	private var _startEnemySpawn: Bool = false; 
	private var overlay = new FlxSprite();

	
	private var lineStyle:LineStyle = { color: FlxColor.BLACK, thickness: 1 };
	private var drawStyle:DrawStyle = { smoothing: true };

	private var _tutStateTracker:Int = 1; 
	private var _tutText: FlxTypeText = new FlxTypeText(0, 200, FlxG.width, "", 30);

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
		
		_map = Constants.loadMap(_level);
		_enemySpawnPosition = _level.start;
		_goalPosition = _level.goal;
		_possiblePaths = new Array<Array<FlxPoint>>();
		addPath(_map.findPath(_enemySpawnPosition, _goalPosition.copyTo()));
		
		// Add groups

		collisionController = new CollisionController(_goalPosition);
		bullets = collisionController.bullets;
		emitters = collisionController.emitters;
		enemies = collisionController.enemies;
		_towers = collisionController.towers;
		gunBases = collisionController.gunBases; 
		towerIndicators = collisionController.towerIndicators;
		
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
		_topGui = HUD.hud;
		_enemyText = HUD.hud.enemyText;
		_waveText = HUD.hud.waveText;
		
		// Set up miscellaneous items: center text, buildhelper, and the tower range image
		
		_centerText = new FlxText( -200, FlxG.height / 2 - 20, FlxG.width, "", 16);
		_centerText.alignment = CENTER;
		_centerText.borderStyle = SHADOW;

		_layerNum = 0;
		_currTowerStartIndex = 0;
		
		#if flash
		_centerText.blend = BlendMode.NORMAL;
		#end
		
		// Add everything to the state
		
		add(_map);
		collisionController.addToState(this);
		add(inGameMenu);
		add(_topGui);
		add(_centerText);
		
		// Call this to set up for first wave
		
		killedWave();

		if (_level.isTutorial) {
			overlay.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK, true); 
			overlay.alpha = 0.8; 
			add(overlay);
			//turn on and off overlay? or make it smaller according to what part you're talking about?

			_tutText.alignment = "center";
			add(_tutText);
			_tutText.resetText("Welcome to permafrost. \n \n \nPlease click anywhere to continue.");
			_tutText.start();
			isTutorial = true;


			//TODO: Fix this so it doesn't need extra canvas variable
			//not sure if this is useful or not, but red square built on this 
			canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true);
			add(canvas);
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
		_enemyText.visible = false;
	}
	
	override public function update(elapsed:Float):Void
	{
		// Update enemies left indicator
		// var clickedTower = collisionController.overlapsTower(Std.int(FlxG.mouse.x), Std.int(FlxG.mouse.y));
		// if (clickedTower != null ) {
		// 	trace(clickedTower.children);
		// }
		
		_enemyText.text = "Enemies left: " + enemiesToKill;
		
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

		// collision controller updates

		collisionController.update(elapsed);

		if (!_level.isTutorial) {
			// Controls mouse clicks, which either build a tower or offer the option to upgrade a tower.
			
			if (FlxG.mouse.justReleased)
			{
				if (inGameMenu.removingMode) {
					popMaterial(); 
					inGameMenu.removingMode = false; 
				}

				else if (inGameMenu.placingMode) {
					// inGameMenu.buildingMode = true; 
					buildTower();
					inGameMenu._towerRange.visible = true;

				}

				else if (inGameMenu.buyingMode) {
					inGameMenu._towerRange.visible = false; 
					if (InGameMenu.currItem < 3) {
						buildGunBase();  
						InGameMenu.currItem = -1; 
					}
					else if (InGameMenu.currItem >= 3 && InGameMenu.currItem < 6) {
						buildFoundation(InGameMenu.currItem);
						InGameMenu.currItem = -1; 
					}
					inGameMenu.buyingMode = false; 
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
			
			// Controls wave spawning, enemy spawning, 
			
			if (enemiesToKill == 0 && _towers.length > 0)
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
				
				if (_spawnCounter > _spawnInterval * FlxG.updateFramerate && enemiesToSpawn > 0)
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

	public function removeTower(tower:Tower):Void{
		_towers.remove(tower, true);
		_map.setTile(Std.int(tower.x / Constants.TILE_SIZE), Std.int(tower.y / Constants.TILE_SIZE), 0, false);
		
		// Remove the indicator for this tower as well
		for (indicator in towerIndicators)
		{
			if (indicator.x ==  tower.getMidpoint().x - 1 && indicator.y ==  tower.getMidpoint().y - 1)
			{
				towerIndicators.remove(indicator, true);
				indicator.visible = false;
				indicator = null;
			}
		}

		for (c in tower.children) {
			remove(c);
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

			removeTower(InGameMenu.towerSelected);
			
			// If there are no towers, having the tutorial text and sell button is a bit superfluous
			if (_towers.countLiving() == -1 && _towers.countDead() == -1)
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
		var xPos:Float = (FlxG.mouse.x - (FlxG.mouse.x % Constants.TILE_SIZE)) + Constants.TILE_SIZE/2 - 18;
		var yPos:Float = (FlxG.mouse.y - (FlxG.mouse.y % Constants.TILE_SIZE)) + Constants.TILE_SIZE/2 - 18;
		
		// Can't place towers on other towers
		for (tower in _towers)
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
		
		var tower: Tower = new Tower(xPos, yPos, inGameMenu.towerPrice, towerBlocks);
		_towers.add(tower);
		var level = 0; 
		for (t in towerBlocks.slice(_currTowerStartIndex)) {
			var xpos = tower.x+tower.origin.x;
            var ypos = tower.y+tower.origin.y-level*Constants.HEIGHT_OFFSET;
            level++;
            t.setPosition(xpos,ypos);
		}

		// _map.setTile(Std.int(xPos / Constants.TILE_SIZE), Std.int(yPos / Constants.TILE_SIZE), 1, false);
		
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
	}

	/** A function that adds a new gunbase and then iterates the number of layers in the tower. **/
	private function buildGunBase(): Void { 
		addMaterial(new GunBase(FlxG.width-180, 500-_layerNum*(Constants.HEIGHT_OFFSET+5))); 
		_layerNum++;
	}

	/** A function that adds a new foundation and then iterates the number of layers in the tower. **/
	private function buildFoundation(ItemNum: Int): Void { 
		addMaterial(new Foundation(FlxG.width-180, 500-_layerNum*Constants.HEIGHT_OFFSET, ItemNum)); 
		_layerNum++; 
	}

	/** A function that adds a gunBase or foundation to the towerBlocks list. **/
	private function addMaterial(obj:TowerBlock):Void{
        towerBlocks.push(obj);
        add(obj);
    }

    private function popMaterial():TowerBlock {
    	var obj = towerBlocks.pop(); 
    	if (obj != null) {
    		remove(obj);
    	}
    	return obj; 
    }

	
	/**
	 * Used to display either the wave number or Game Over message via the animated fly-in, fly-out text.
	 * 
	 * @param	End		Whether or not this is the end of the game. If true, message will say "Game Over! :("
	 */
	private function announceWave(End:Bool = false):Void
	{
		_centerText.x = -200;
		_centerText.text = "Wave " + wave;
		
		if (End)
			_centerText.text = "Game Over! :(";
		
		FlxTween.tween(_centerText, { x: 0 }, 2, { ease: FlxEase.expoOut, onComplete: hideText });
		
		_waveText.text = "Wave: " + wave;
		_waveText.size = 16;
		_waveText.visible = true;
	}
	
	/**
	 * Hides the center text message display on announceWave, once the first tween is complete.
	 */
	private function hideText(Tween:FlxTween):Void
	{
		FlxTween.tween(_centerText, { x: FlxG.width }, 2, { ease: FlxEase.expoIn });
	}
	
	/**
	 * Spawns the next wave. This increments the wave variable, displays the center text message,
	 * sets the number of enemies to spawn and kill, hides the next wave button, and shows the
	 * notification of the number of enemies.
	 */
	private function spawnWave():Void
	{
		if (_gameOver)
			return;
		
		wave++;
		announceWave();
		enemiesToKill = 5 + wave;
		enemiesToSpawn = enemiesToKill;
		
		_nextWaveButton.visible = false;
		
		_enemyText.visible = true;
		_enemyText.size = Constants.HUD_TEXT_SIZE;
	}
	
	/**
	 * Spawns an enemy. Decrements the enemiesToSpawn variable, and recycles an enemy from enemies and then initiates
	 * it and gives it a path to follow.
	 */
	private function spawnEnemy():Void
	{
		enemiesToSpawn--;
		
		var enemy = enemies.recycle(Enemy.new.bind(0, 0));
		enemy.init(_enemySpawnPosition.x, _enemySpawnPosition.y - 12);

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
	 * Called when you lose. Of course!
	 */
	private function loseGame():Void
	{
		_gameOver = true;
		
		collisionController.kill();
		inGameMenu.kill();
		
		announceWave(true);
		
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
		var _tutTextList: Array<String> = ["Welcome to permafrost. \nPlease click anywhere to continue.", 
											"Your job is to stop the greedy kids from getting to the North Pole. \n 
											Start by building your first Snowman Defense Turret.", 
											"Great! Now click build!", 
											"Place your tower on the map. \nClick on your tower to check its health and attack.", 
											"Placing your tower will start the first wave of pesky kids.", 
											"Well done! We are going to need a stronger tower for wave 2. \n
											We can add more snow to increase health.", 
											"Now add a Snowman Turret.", 
											"You can also give your Snowman Turret different ammo that will change its attack style.", 
											"Each snowman turret in a tower can have an ammo type.", 
											"And each tower can be up to 3 layers high.", 
											"Now build your upgraded tower and good luck!"];

			if (_tutStateTracker == 1) {
				//check to see if they click on gunbase 1 
				if (InGameMenu.currItem == 0) {
					buildGunBase(); 
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
				if (_towers.length == 1 && enemiesToSpawn == 1) {
					trace("got here");
					_startEnemySpawn = true; 
				}
				if (_startEnemySpawn) {
					_tutStateTracker += 1; 
				}
			}

			if (_tutStateTracker == 5) {
				trace("wowie");
			}


		if (FlxG.mouse.justReleased) {
			_tutText.resetText(_tutTextList[_tutStateTracker]);
			_tutText.start();

			if (_tutStateTracker == 0) {
				_tutStateTracker+= 1; 
			}


			if (_tutStateTracker == 4) {
				//MAKE SURE TO ALSO SHOW HEALTH AND STATS 
				if (_towers.length == 1) {
					//release slow wave of few kids
					enemiesToSpawn = 1; 
					spawnEnemy(); 
				}
			} 



	
		}
		//fix tutorial button 
		//make sure store doesn't cover map
		//FIX MONEY ERRORS
		//FIX SLOWNESS OF TEXT AND ADD SKIP BUTTON
		//BLACK OVERLAY BEHIND
		//PROPER POSITIONING 
		//FLASH BUTTON THAT NEEDS TO BE CLICKED AND DISABLE EVERYTHING ELSE 
			//PLAY REJECT SOUND IF CLICKED UNTIL THE RIGHT TIME 

		//REMOVE MENU STUFF ON BOTTOM
		//SELLING FUNCTIONALITY 

		//disable clicks until proper things clicked 
		//adjust speed of things clicked 

		//different states for different text
		//stored in list and iterate through depending on what click they're at
		//click changes index in list and therefore text 
		//need overlay 

		//should track click state and sequence of actions 
	}
}
