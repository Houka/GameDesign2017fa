package;

import flixel.FlxGame;
import openfl.display.Sprite;
import gameStates.MenuState;
import Logging;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState, 2,60,60,true,false));

        Logging.initialize(771, 4, false, true);
        Logging.recordPageLoad();
	}
}