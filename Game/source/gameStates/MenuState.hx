package gameStates;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG; 
import openfl.Lib;

class MenuState extends FlxState
{
	
	override public function create():Void
	{
		super.create();

		var text = new flixel.text.FlxText(0, 0, 0, "eMpTy Defense", 50);
		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter();
		text.y -=100;
		add(text);
		
		var playButton: FlxButton = new FlxButton(0, 0, "Play", nextState);
		playButton.screenCenter();
		add(playButton);

		var quitButton: FlxButton = new FlxButton(0, 0, "Quit", quitGame);
		quitButton.screenCenter();
		quitButton.y += 50;
		add(quitButton);
	}

	private function quitGame():Void 
	{
        Lib.close();
	}

	private function nextState():Void 
	{
		FlxG.switchState(new GameState());
	}
}
