package gameStates;

import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import openfl.Lib;
import utils.Button;
import Constants;
import Levels;

class WinState extends FlxSubState
{	
	private var _level: Level;  
	
	public function new(level: Level):Void {
        super();
        _level = level; 
    }
	
	override public function create():Void
	{
		super.create();
		
		var text = new flixel.text.FlxText(0, 0, 0, "Win State", 50);
		text.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter();
		text.y -=100;
		
		var replayButton: FlxButton = new FlxButton(0, 0, "Replay Level", 
			function() {FlxG.switchState(new PlayState(_level));});
		replayButton.screenCenter();
		
		var menuButton: FlxButton = new FlxButton(0, 0, "Menu", 
			function() {FlxG.switchState(new MenuState());});
		menuButton.screenCenter();
		menuButton.y += 50; 

		// TODO: Set button to next level from current
		if (Levels.currentLevel >= 0 && Levels.currentLevel < Levels.levels.length - 1){
			var nextLevelButton: FlxButton = new FlxButton(0, 0, "Next Level", 
				function() {FlxG.switchState(new PlayState(Levels.levels[Levels.currentLevel+1].level));});
			nextLevelButton.screenCenter();
			nextLevelButton.y += 100; 
			add(nextLevelButton);
		}

		add(text);
		add(replayButton);
		add(menuButton);
	}
}