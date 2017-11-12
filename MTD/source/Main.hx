package;

import flixel.FlxGame;
import flixel.FlxG;
import openfl.display.Sprite;
import gameStates.*;
import Logging;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, test.GameState, 2,60,60,true,false));

        Logging.initialize(771, 5, false, true);
        Logging.recordPageLoad();
        Logging.assignABTestValue(FlxG.random.int(1, 3));
        Logging.recordABTestValue();
	}
}