package controllers;

import flixel.FlxG;
import openfl.Lib;

/**
 * The KeyboardController maps key presses to various flags for other
 * controllers to read in sync with the update step.
 */

class KeyboardController
{
    static private var _paused:Bool;

    public function new()
    {
        _paused = false;
    }

    static public function quit():Void
    {
        Lib.close();
    }

    static public function isPaused():Bool
    {
        return _paused;
    }

    public function update(elapsed:Float):Void
    {
        if(FlxG.keys.anyJustPressed([P, SPACE]))
            _paused = !_paused;
        
        if(FlxG.keys.anyJustPressed([Q]))
            quit();
    }
}