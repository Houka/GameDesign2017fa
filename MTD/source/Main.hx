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

        Logging.initialize(771, 2, false, true);
        Logging.recordPageLoad();
        Logging.recordLevelStart(1.0);
        Logging.recordEvent(1, "Hello world");
        Logging.recordLevelEnd();
	}
}