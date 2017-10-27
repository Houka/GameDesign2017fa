package gameStates;

import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import utils.Button;
import Constants;
import Levels;

class LoseState extends FlxSubState
{	
	private var _level:Level; 
	
	public function new(level: Level):Void {
        super();
        _level = level; 
    }
	
	override public function create():Void
	{
		super.create();
		
		var text = new flixel.text.FlxText(0, 0, 0, "Lose State", 64);
		text.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter();
		text.y -=100;
		add(text);
		
		var restartButton: FlxButton = new FlxButton(0, 0, "Restart", 
			function() {FlxG.switchState(new PlayState(_level));});
		restartButton.screenCenter();
		add(restartButton);
		
		var menuButton: FlxButton = new FlxButton(0, 0, "Menu", 
			function() {FlxG.switchState(new MenuState());});
		menuButton.screenCenter();
		menuButton.y += 50; 
		add(menuButton);
	}
}