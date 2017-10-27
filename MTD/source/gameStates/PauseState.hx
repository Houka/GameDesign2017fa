package gameStates;

import flixel.FlxSubState;
import flixel.FlxG;
import flixel.util.FlxColor;

class PauseState extends FlxSubState
{	
	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "Pause", 64);
		text.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([P])) {
			close();
		}
	}	
}