package gameStates;

import flash.display.BlendMode;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.tile.FlxTilemap;
import openfl.Lib;
import gameObjects.Enemy;
import utils.Button;
import Constants;

class MenuState extends FlxState
{
	private static inline var SELECTION_MENU_OFFSET_X:Int = -250;

	private var _level:Level;
	private var _startPosition:FlxPoint;
	private var _endPosition:FlxPoint;
	
	private var _enemy:Enemy;
	private var _map:FlxTilemap;
	
	/**
	 * Creates the title menu screen.
	 */
	override public function create():Void
	{
		// Change the default mouse to an inverted triangle.
		Constants.toggleCursors(CursorType.Normal);

		// camera and framerate settings
		FlxG.cameras.bgColor = FlxColor.WHITE;
		FlxG.timeScale = 1;
		
		// Load a map from CSV data; note that the tile graphic does not need to be a file; in this case, it's BitmapData.
		_level = Constants.demo;
		_map = Constants.loadMap(_level, true);
		_startPosition  = _level.start;
		_endPosition = _level.goal;

		// Menu BG
		var menuBG = new FlxSprite(0,0, AssetPaths.menu__png);
		menuBG.setPosition(FlxG.width/2 - menuBG.origin.x + SELECTION_MENU_OFFSET_X, FlxG.height/2 - menuBG.origin.y);
		menuBG.scrollFactor.x = menuBG.scrollFactor.y = 0;
		menuBG.alpha = 0.85;

		// Game title
		var headline = new FlxText(SELECTION_MENU_OFFSET_X, FlxG.height/2 - menuBG.origin.y, FlxG.width, "MTD", 75);
		headline.scrollFactor.x = headline.scrollFactor.y = 0;
		headline.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		headline.alignment = CENTER;
		
		// Credits
		var credits = new FlxText(SELECTION_MENU_OFFSET_X, FlxG.height/2 + menuBG.origin.y - 10, FlxG.width, "Sun Bear Studios", 14);
		credits.scrollFactor.x = credits.scrollFactor.y = 0;
		credits.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,1);
		credits.alignment = CENTER;
		
		// Level select buttons
		var buttonSize = 20;
		var levelNames = ["Tutorial", "Level 1", "Level 2", "Level3", "Level4", "Level5", "Level6", "Level7", "Level8", "Level9", "Level10"];
		var levels = [Constants.tutorial, Constants.level1, Constants.level2, Constants.level3, Constants.level4, Constants.level5, Constants.level6, 
						Constants.level7, Constants.level8, Constants.level9, Constants.level10];
		var levelButtons = [];
		for (i in 0...levelNames.length){
			var levelButton = new Button(0, 0, levelNames[i], startGame.bind(levels[i]),100);
			levelButton.label.size = buttonSize;
			levelButton.screenCenter();
			levelButton.y += i*25 - 75;
			levelButton.x += SELECTION_MENU_OFFSET_X;
			levelButtons.push(levelButton);
		}
		
		// The enemy that repeatedly traverses the screen.
		_enemy = new Enemy();
		enemyFollowPath();

		// allow camera movement
		var LEVEL_MIN_X = 0;
		var LEVEL_MIN_Y = 0;
		var LEVEL_MAX_X = Constants.TILE_SIZE*_level.mapWidth;
		var LEVEL_MAX_Y = Constants.TILE_SIZE*_level.mapHeight;

		FlxG.camera.setScrollBoundsRect(LEVEL_MIN_X, LEVEL_MIN_Y,
			LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true);
		FlxG.camera.follow(_enemy, LOCKON, 1);
		
		// Add everything to the state
		add(_map);
		add(_enemy);
		add(menuBG);
		add(headline);
		add(credits);
		for (b in levelButtons)
			add(b);

		super.create();
	}
	
	/**
	 * Starts the enemy on the map path.
	 */
	public function enemyFollowPath(?_):Void
	{
		_enemy.setPosition(_startPosition.x, _startPosition.y - Constants.TILE_SIZE*2);
		var path:Array<FlxPoint> = _map.findPath(_startPosition, _endPosition);
		var lastPoint = path[path.length - 1];
		lastPoint.x = path[path.length - 2].x;
		lastPoint.y += 20;
		_enemy.followPath(path, 500, enemyFollowPath);
	}
	
	/**
	 * Activated when clicking "Play" or pressing P; switches to the playstate.
	 */
	private function startGame(level:Level):Void
	{
		FlxG.switchState(new PlayState(level));
	}
}