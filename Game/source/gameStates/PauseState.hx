package gameStates;

import flixel.FlxSubState;
import flixel.FlxG;

class PauseState extends FlxSubState
{	
	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "Pause State", 64);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([P, SPACE])) {
			close();
		}
	}	
}