package gameStates;

import flixel.FlxSubState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import openfl.Lib;
using Lambda;

class LoseState extends FlxSubState
{	
	override public function create():Void
	{
		super.create();
		
		var text = new flixel.text.FlxText(0, 0, 0, "Lose State", 64);
		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter();
		text.y -=100;
		add(text);
		
		/*var restartButton: FlxButton = new FlxButton(0, 0, "Restart", 
			function() {FlxG.switchState(new GameState(this.level,this.path));});
		restartButton.screenCenter();
		add(startButton);
		
		var menuButton: FlxButton = new FlxButton(0, 0, "Menu", 
			function() {FlxG.switchState(new GameState(this.level,this.path));});
		medLevelButton.screenCenter();
		medLevelButton.y += 50; 
		add(medLevelButton);*/
		
		var quitButton: FlxButton = new FlxButton(0, 0, "Quit", quitGame);
		quitButton.screenCenter();
		quitButton.y += 100;
		add(quitButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([P, SPACE])) {
			close();
		}
	}
	
	private function quitGame():Void 
	{
        Lib.close();
	}
}