package;

import flixel.FlxGame;
import openfl.display.Sprite;
import gameStates.*;
import Logging;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, test.GameState, 2,60,60,true,false));

        Logging.initialize(771, 4, true, true);
        Logging.recordPageLoad();
	}
}