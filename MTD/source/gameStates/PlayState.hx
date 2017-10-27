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
import AssetPaths;
import Type; 

class PlayState extends FlxState
{
	// Public variables
	public var enemiesToKill:Int = 0;
	public var wave:Int = 0;
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
		
		_map = Levels.loadMap(_level);
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
		
		// Call this to set up for first wave
		
		killedWave();
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

		// collision controller updates

		collisionController.update(elapsed);

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
		
		// Controls wave spawning, enemy spawning, 
		
		if (enemiesToKill == 0 && collisionController.towers.length > 0)
		{
			_waveCounter -= Std.int(FlxG.timeScale);
			_nextWaveButton.text = "[N]ext Wave in " + Math.ceil(_waveCounter / FlxG.updateFramerate);
			
		
			if (wave >= _level.waves.length)
				winGame();
			else if (_waveCounter <= 0)
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
		
		super.update(elapsed);
	} // End update

	public function removeTower(tower:Tower):Void{
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

			removeTower(InGameMenu.towerSelected);
			
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
	}

	/** A function that adds a new gunbase and then iterates the number of layers in the tower. **/
	private function buildGunBase(): Void { 
		addMaterial(new GunBase(FlxG.width-180, 500-_layerNum*Constants.HEIGHT_OFFSET)); 
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
}
