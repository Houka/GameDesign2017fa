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
	private var background:FlxSprite;
	override public function create():Void
	{
		super.create();
		background = new FlxSprite(0,0);
		background.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		background.alpha = 0;
		add(background);

		var text = new flixel.text.FlxText(0, 0, 0, "Paused", 64);
        text.setFormat("assets/fonts/almonte_woodgrain.ttf", 72, FlxColor.fromInt(0xffffffff));
		text.scale.x = text.scale.y = 2;
		text.screenCenter();
		text.y-=200;
		add(text);

		var text2 = new flixel.text.FlxText(0, 0, 0, "P to resume\nR to restart\nQ for Level Select", 70);
        text2.setFormat("assets/fonts/almonte_woodgrain.ttf", 70, FlxColor.fromInt(0xff70C2FE));
		text2.screenCenter();
		text2.y += 40;
		add(text2);

        var secs = 0.5;
        FlxTween.tween(text, { y: text.y }, secs, { ease: FlxEase.expoOut});
        FlxTween.tween(text2, { y: text2.y }, secs, { ease: FlxEase.expoOut});
        text.y+=FlxG.height;
        text2.y+=FlxG.height;
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


		if (background.alpha <0.5)
			background.alpha += 0.05;
	}	
}