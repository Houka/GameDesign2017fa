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

class PlayState extends FlxState
{
	// Public variables
	public var enemiesToKill:Int = 0;
	public var enemiesToSpawn:Int = 0;
	public var wave:Int = 0;
	
	// Game Object groups
	public var collisionController:CollisionController;
	public var bullets:FlxTypedGroup<Bullet>;
	public var emitters:FlxTypedGroup<EnemyExplosion>;
	public var enemies:FlxTypedGroup<Enemy>;
	public var towerIndicators:FlxTypedGroup<FlxSprite>;
	private var _towers:FlxTypedGroup<Tower>;

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
		
		Constants.playMusic("bg_music");
		
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
		towerIndicators = collisionController.towerIndicators;
		
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
		
		#if flash
		_centerText.blend = BlendMode.INVERT;
		#end
		
		// Add everything to the state
		
		add(_map);
		collisionController.addToState(this);
		add(inGameMenu);
		add(_topGui);
		add(_centerText);
		
		// Call this to set up for first wave
		
		killedWave();
		
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

		// Controls mouse clicks, which either build a tower or offer the option to upgrade a tower.
		
		if (FlxG.mouse.justReleased)
		{
			if (inGameMenu.buildingMode)
			{
				buildTower();
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
		var xPos:Float = FlxG.mouse.x - (FlxG.mouse.x % Constants.TILE_SIZE);
		var yPos:Float = FlxG.mouse.y - (FlxG.mouse.y % Constants.TILE_SIZE);
		
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
		
		_towers.add(new Tower(xPos, yPos, inGameMenu.towerPrice));

		_map.setTile(Std.int(xPos / Constants.TILE_SIZE), Std.int(yPos / Constants.TILE_SIZE), 1, false);
		
		inGameMenu.builtFirstTower();
		
		Constants.play("build");
		
		HUD.money -= inGameMenu.towerPrice;
		inGameMenu.towerPrice += Std.int(inGameMenu.towerPrice * 0.3);
		_towerButton.text = "Buy [T]ower ($" + inGameMenu.towerPrice + ")";
		inGameMenu.toggleMenus(General);
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
}
