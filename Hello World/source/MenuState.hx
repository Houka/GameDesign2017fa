package;

import flixel.FlxState;
import flixel.ui.FlxButton; 

class MenuState extends FlxState
{
	private var playButton:FlxButton; 
	
	override public function create():Void
	{
		// playButton = new FlxButton(0, 0, "Play", playClicked);
		// add(playButton);
		// super.create();
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}

	private function playClicked():Void { 
		FlxG.switchState(new PlayState());
	}
}