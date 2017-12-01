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

import utils.*;

class Homebase extends FlxGroup{
	private static inline var yOffset:Int=-20;
	private static inline var gap:Int=15;

	public var point:FlxPoint;
	public var midpoint:FlxPoint;
	public var gameover:Bool;
	public var health(default, set):Int;

	private var xOffset:Int;
	private var healthSprites:FlxTypedGroup<FlxSprite>;
	private var homebase:FlxSprite;

	public function new(X:Int, Y:Int, Health:Int){
		super();

		// init stats
		gameover = false;
		health = Health;

		// make homebase
		homebase = new FlxSprite(X,Y, AssetPaths.homebase__png);
		var diffW = homebase.width - Util.TILE_SIZE;
		var diffH = homebase.height - Util.TILE_SIZE;
		homebase.setPosition(X - diffW/2, Y - diffH/2);
		add(homebase);

		midpoint = homebase.getMidpoint();
		point = new FlxPoint(X,Y);

		// make hearts around homebase to show life
		// max life is 5
		healthSprites = new FlxTypedGroup<FlxSprite>();
		var healthSpritesWidth = gap * (health);
		xOffset = Std.int(homebase.width/2 - healthSpritesWidth/2);
		for (h in 0...health)
		{
			var heart = new FlxSprite(homebase.x+xOffset + gap * h, Y+yOffset);
			heart.loadGraphic(AssetPaths.heart__png, true, 16, 16);
			heart.animation.add("beating",[0,1,2,1,0,0,0,0,0,0,0],10,true);
			heart.animation.play("beating");
			healthSprites.add(heart);
		}
		add(healthSprites);
	}

	override public function update(elapsed:Float){
		super.update(elapsed);
		healthSprites.update(elapsed);
	}

	public function hurt(damage:Int){
		health -= damage;
		//Log that player sustained damage
		var logString = "Level:"+LevelData.currentLevel+" HP:"+health;
		Logging.recordEvent(3,logString);
		if (health <= 0){
			gameover = true;
			kill();
		}
	}

	private function set_health(Health:Int):Int{
		if (health >= 0 && health > Health){
			healthSprites.members[Health].kill();
			FlxTween.linearPath(homebase, [FlxPoint.get(homebase.x+5, homebase.y), FlxPoint.get(homebase.x-5, homebase.y),FlxPoint.get(homebase.x, homebase.y)], 0.1, true, {});
		}
		if (health < Health){
			var h = healthSprites.recycle(FlxSprite);
			h.reset(point.x+xOffset + gap * (Health-1), point.y+yOffset);
		}

		health = Health;
		return health;
	}
}
