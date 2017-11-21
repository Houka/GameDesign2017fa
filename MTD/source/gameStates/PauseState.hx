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
import openfl.Assets;
using StringTools;

class PauseState extends FlxSubState
{   
	override public function create():Void
	{
		super.create();
		var background = new FlxSprite(0,0);
		background.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);

		var text = new flixel.text.FlxText(0, 0, 0, "Paused", 64);
		text.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text.screenCenter();
		add(text);

		var text2 = new flixel.text.FlxText(0, 0, 0, "press [P] to resume, [R] to restart, or [Q] to exit", 32);
		text2.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text2.screenCenter();
		text2.y += 40;
		add(text2);
	}

	override public function add(Object:FlxBasic):FlxBasic{
		var result = super.add(Object);
		// needed to prevent camera scrolling from affecting this state
		if (Std.is(Object, FlxObject)){
			cast(Object, FlxObject).scrollFactor.set(0,0);
		}

		return result;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([P])) {
			close();		
		}
		if (FlxG.keys.anyJustPressed([Q]))
			FlxG.switchState(new LevelSelectState());   
		if (FlxG.keys.anyJustPressed([R])) {
			if (LevelData.currentLevel == 0)
				GameState.tutorialEvent = 0;
			FlxG.switchState(new GameState());
		}
	}	
}