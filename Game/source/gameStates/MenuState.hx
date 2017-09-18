package gameStates;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.FlxG; 

class MenuState extends FlxState
{
	
	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(140, 50, 0, "Modular Tower Defense", 25);
		add(text);
		var playButton: FlxButton = new FlxButton(0, 0, "Play", nextState);
		playButton.label.size = 10;
		playButton.screenCenter();
		add(playButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

	}

	private function nextState():Void 
	{
		FlxG.switchState(new GameState());
	}
}
