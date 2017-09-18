package controllers;

import flixel.FlxG;
import flixel.FlxBasic;

/**
 * The KeyboardController maps key presses to various flags for other
 * controllers to read in sync with the update step.
 */

class KeyboardController extends FlxBasic
{
    static private var _quit:Bool;
    static private var _paused:Bool;

    public function new()
    {
        super();
        _quit = false;
        _paused = false;
    }

    static public function quit():Bool
    {
        return _quit;
    }

    static public function paused():Bool
    {
        return _paused;
    }

    override public function update(elapsed:Float):Void
    {
        if(FlxG.keys.anyJustPressed([P, SPACE]))
        {
            _paused = !_paused;
        }
        if(FlxG.keys.anyJustPressed([Q]))
        {
            _quit = !_quit;
        }
    }
}