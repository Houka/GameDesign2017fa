package gameStates;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG; 
import openfl.Lib;
using Lambda; 

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
		
		var playButton: FlxButton = new FlxButton(0, 0, "Easy", 
			function() {FlxG.switchState(new GameState(AssetPaths.easyMap__json,Constants.EASY_MAP));});
		playButton.screenCenter();
		add(playButton);

		var medLevelButton: FlxButton = new FlxButton(0, 0, "Medium", 
			function() {FlxG.switchState(new GameState(AssetPaths.medMap__json,Constants.MED_MAP));});
		medLevelButton.screenCenter();
		medLevelButton.y += 50; 
		add(medLevelButton);

		var hardLevelButton: FlxButton = new FlxButton(0, 0, "Hard", 
			function() {FlxG.switchState(new GameState(AssetPaths.hardMap__json,Constants.HARD_MAP));});
		hardLevelButton.screenCenter();
		hardLevelButton.y += 100; 
		add(hardLevelButton);

		var quitButton: FlxButton = new FlxButton(0, 0, "Quit", quitGame);
		quitButton.screenCenter();
		quitButton.y += 150;
		add(quitButton);
	}

	private function quitGame():Void 
	{
		#if !flash 
        	Lib.close();
        #end
	}

}
