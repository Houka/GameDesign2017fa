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
		addChild(new FlxGame(0, 0, MenuState, 2,60,60,true,false));

        Logging.initialize(771, 7, true, true);
        Logging.recordPageLoad();
        Logging.assignABTestValue(FlxG.random.int(1, 2));
        Logging.recordABTestValue();
	}
}