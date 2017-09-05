package gameStates;

import flixel.FlxState;
import flixel.FlxG; 

class LoadingState extends FlxState
{
	var time: Int = 0; 
	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "Loading State", 64);
		text.screenCenter();
		add(text);
	
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (time > 100) { 
			FlxG.switchState(new MenuState());
			time = 0;  
		}
		time++; 
	}
}
