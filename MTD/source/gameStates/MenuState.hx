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
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import openfl.Lib;
import gameObjects.Enemy;
import utils.Button;
import Constants;
import LevelData;
import Levels;
import utils.Sounds;
import utils.Util;

class MenuState extends FlxState
{
	private static inline var SELECTION_MENU_OFFSET_X:Int = -250;
	private static inline var SELECTION_MENU_OFFSET_Y:Int = -50;

	private var _map:FlxTilemap;
	private var _snows:FlxTypedGroup<FlxSprite>;
	private var headline:FlxText;
	private var info:FlxText;
	
	/**
	 * Creates the title menu screen.
	 */
	override public function create():Void
	{
		var font = "assets/fonts/almonte_woodgrain.ttf";

		// make level
		_map = new FlxTilemap();
		_map.loadMapFromCSV("assets/maps/menu.csv", "assets/tiles/auto_tilemap_menu.png", Util.TILE_SIZE, Util.TILE_SIZE, AUTO);

		// camera and framerate settings
		FlxG.cameras.bgColor = FlxColor.fromInt(0xFF508AAD);
		FlxG.timeScale = 1;

		// make bg visual snow effect
		_snows = new FlxTypedGroup<FlxSprite>();
		for (i in 0...300){
			addSnow(_snows);
		}

		// Game title
		headline = new FlxText(0,0,0, "Permafrost", 140);
		headline.setFormat(font, 72, FlxColor.fromInt(0xff70C2FE));
		headline.scrollFactor.x = headline.scrollFactor.y = 0;
		headline.scale.x = headline.scale.y  = 2;
		headline.screenCenter();
		headline.y -= 50;

		// Press Enter To Play Text
		info = new FlxText(0,0, 0, "Click Anywhere", 44);
		info.setFormat(font, 44, FlxColor.fromInt(0xffAFEEFE));
		info.scrollFactor.x = info.scrollFactor.y = 0;
		info.screenCenter();
		info.y += 100;
		
		// Credits
		var credits = new FlxText(0,0,0, "Sun Bear Studios (c) 2017", 14);
		credits.setFormat("arial", 14, FlxColor.fromInt(0xffAFEEFE));
		credits.scrollFactor.x = credits.scrollFactor.y = 0;
		credits.screenCenter();
		credits.y += 260;

		// Privacy Policy
		var discolsureMSG = "In order to make improvements and provide the best possible experience, "+
			"this game anonymously records user interactions and IP addresses. No personal information is recorded.";
		var disclosure = new FlxText(FlxG.width/6, FlxG.height-64, FlxG.width*2/3, discolsureMSG, 12);
		disclosure.setFormat("arial", 15, FlxColor.fromInt(0xff508AAD));
		disclosure.scrollFactor.x = disclosure.scrollFactor.y = 0;

		// homebase sprite
		var homebase = new FlxSprite(4*Util.TILE_SIZE-50,7*Util.TILE_SIZE-30,"assets/images/homebase.png");

		// start music
		Sounds.playBGM("JohnGameLoop");
		
		// Add everything to the state
		add(_map);
		add(homebase);
		add(_snows);
		add(headline);
		add(credits);
		add(info);
		add(disclosure);

		super.create();

		// transition the headline text and info text up and down
		ease1(headline,50);
		ease1(info,-20);
	}
	
    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (FlxG.keys.anyJustPressed([ENTER]) || FlxG.mouse.justReleased) {
            levelSelect();
        }

        // remove snow when it goes off screen and then create another one
        for (s in _snows){
        	if (s.y > FlxG.height && !s.isOnScreen(FlxG.camera)){
        		s.kill();
        		addSnow(_snows);
        	}
        }
    }
	
	/**
	 * Switches to Level Select screen.
	 */
	private function levelSelect():Void
	{
		Sounds.play("start_game");
		FlxG.switchState(new LevelSelectState());
	}

	/*
	*	creates a snowfall flxsprite
	*/
	private function addSnow(group:FlxTypedGroup<FlxSprite>):Void
	{	
		var speed = Std.random(100)+300;
	    var snow = group.recycle(FlxSprite);
		snow.makeGraphic(Std.int(speed/2), Std.random(5)+1, 0xFFFFFFFF);
		snow.setPosition(Std.random(FlxG.width*3)-FlxG.width*2,-Std.random(Std.int(FlxG.height))-snow.height);

		snow.angle = 60;
		snow.velocity.set(speed*2, 0);
		snow.velocity.rotate(FlxPoint.weak(0,0), snow.angle);
		snow.alpha = 1-speed/400.;
	}

	// tweens for text
	private function ease1(text:FlxText, ?radius:Int=100):Void {
		var secs = 10;
		var ease = function(t) FlxTween.linearMotion(text, text.x, text.y, text.x, text.y+2*radius, secs, true, 
			{ ease: FlxEase.expoInOut, onComplete: function(t) ease1(text,radius)});
		FlxTween.linearMotion(text, text.x, text.y, text.x, text.y-2*radius, secs, true, { ease: FlxEase.expoInOut, onComplete: ease});

	}

}