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
import flixel.group.FlxGroup;
import flixel.system.FlxSound;
import openfl.Lib;
import gameObjects.Enemy;
import utils.Button;
import Constants;
import LevelData;
import Levels;

import utils.Sounds;

class MenuState extends FlxState
{
	private static inline var SELECTION_MENU_OFFSET_X:Int = -250;
	private static inline var SELECTION_MENU_OFFSET_Y:Int = -50;

	private var _level:Demo;
	private var _startPosition:FlxPoint;
	private var _endPosition:FlxPoint;
	
	private var _enemy:Enemy;
	private var _map:FlxTilemap;
	
	/**
	 * Creates the title menu screen.
	 */
	override public function create():Void
	{
		// camera and framerate settings
		FlxG.cameras.bgColor = FlxColor.fromInt(0xff85bbff);
		FlxG.timeScale = 1;
		
		// Load a map from CSV data; note that the tile graphic does not need to be a file; in this case, it's BitmapData.
		_level = Levels.demo;
		_map = Levels.loadMap(_level, true);
		_startPosition  = _level.start;
		_endPosition = _level.goal;

		// Menu BG
		var menuBG = new FlxSprite(0,0, AssetPaths.menu__png);
		menuBG.setPosition(FlxG.width/2 - menuBG.origin.x + SELECTION_MENU_OFFSET_X, FlxG.height/2 - menuBG.origin.y + SELECTION_MENU_OFFSET_Y);
		menuBG.scrollFactor.x = menuBG.scrollFactor.y = 0;
		menuBG.alpha = 0.85;

		// Game title
		var headline = new FlxSprite(0,0, AssetPaths.logo__png);
		headline.setPosition(FlxG.width/2 - headline.origin.x + SELECTION_MENU_OFFSET_X, FlxG.height/2 - menuBG.height/2 + SELECTION_MENU_OFFSET_Y);
		headline.scrollFactor.x = headline.scrollFactor.y = 0;
		headline.alpha = 0.85;
		
		// Credits
		var credits = new FlxText(SELECTION_MENU_OFFSET_X, FlxG.height/2 + menuBG.origin.y + 5 + SELECTION_MENU_OFFSET_Y, FlxG.width, "Sun Bear Studios (c) 2017", 14);
		credits.scrollFactor.x = credits.scrollFactor.y = 0;
		credits.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,1);
		credits.alignment = CENTER;
		
		// Play button
		var playButton = new FlxButton(0,0,"",levelSelect);
		playButton.loadGraphic(AssetPaths.playButton__png, true, 128, 54);
		playButton.setPosition(FlxG.width/2 - playButton.origin.x + SELECTION_MENU_OFFSET_X, FlxG.height/2 + SELECTION_MENU_OFFSET_Y);
		playButton.scrollFactor.x = playButton.scrollFactor.y = 0;

		//Privacy Policy
		var discolsureMSG = "In order to make improvements and provide the best possible experience,"+
			"this game anonymously records user interactions and IP addresses. No personal information is recorded.";
		var disclosure = new FlxText(FlxG.width/6, FlxG.height-64, FlxG.width*2/3, discolsureMSG, 12);
		disclosure.scrollFactor.x = disclosure.scrollFactor.y = 0;
		disclosure.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,1);
		
		// The enemy that repeatedly traverses the screen.
		_enemy = new Enemy();
		_enemy.loadGraphic(AssetPaths.snow1__png);
		enemyFollowPath();

		// allow camera movement
		var LEVEL_MIN_X = 0;
		var LEVEL_MIN_Y = 0;
		var LEVEL_MAX_X = Constants.TILE_SIZE*_level.mapWidth;
		var LEVEL_MAX_Y = Constants.TILE_SIZE*_level.mapHeight;

		FlxG.camera.setScrollBoundsRect(LEVEL_MIN_X, LEVEL_MIN_Y,
			LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true);
		FlxG.camera.follow(_enemy, LOCKON, 1);

		// start music
		if (FlxG.sound.music == null) // don't restart the music if it's already playing
		{
		    FlxG.sound.playMusic(AssetPaths.JohnGameLoop__ogg,0.2,true);
		}
		
		// Add everything to the state
		add(_map);
		add(_enemy);
		add(menuBG);
		add(headline);
		add(credits);
		add(playButton);
		add(disclosure);

		super.create();
	}
	
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (FlxG.keys.anyJustPressed([P])) {
            levelSelect();
        }
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
		_enemy.followPathDemo(path, 500, enemyFollowPath);
	}
	
	/**
	 * Activated when clicking "Start Game" or pressing [P]; switches Level Select screen.
	 */
	private function levelSelect():Void
	{
		Sounds.play("start_game");
		FlxG.switchState(new LevelSelectState());
	}
}