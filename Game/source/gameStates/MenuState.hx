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
		// text.screenCenter();
		add(text);
		var playButton: FlxButton = new FlxButton(0, 0, "Play", nextState);
		playButton.label.size = 10;
		playButton.screenCenter();
		add(playButton);
		// var npcStateButton: FlxButton = new FlxButton(0, 100, "NPC", npcStateSwitch);
		// npcStateButton.screenCenter(); 
		// add(npcStateButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

	}

	private function nextState():Void 
	{
		FlxG.switchState(new GameState());
	}

	private function npcStateSwitch():Void 
	{
		FlxG.switchState(new NPCTestState());
	}
}
