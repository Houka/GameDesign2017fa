package controllers;

import flixel.FlxG;
import openfl.Lib;
using Lambda;

/**
 * @author: Changxu Lu
 */
typedef KeyAndCallback = {
    var keys: Array<flixel.input.keyboard.FlxKey>;
    var callback:Void->Void;
}
class KeyboardController
{

    private var _keyAndCallbackList:Array<KeyAndCallback>;

    public function new()
    {
        _keyAndCallbackList = [];
        addKeyAndCallback([Q],KeyboardController.quit);
    }

    static public function quit():Void
    {
        #if !flash
        Lib.close();
        #end
    }

    /**
    *   Adds into the list of keyboard updates a check for the <keys>. If any of the <keys> are 
    *   pressed, then it will call the corresponding <callback> function. 
    *
    *   <keys>: list of Keys (i.e. [P, SPACE])
    *   <callback>: a function that has no arguments and no returns (i.e. function test():Void {trace("test");})
    */
    public function addKeyAndCallback(keys:Array<flixel.input.keyboard.FlxKey>, callback:Void->Void):Void{
        _keyAndCallbackList.push({keys:keys, callback:callback});
    }

    public function update(elapsed:Float):Void
    {
        for (i in _keyAndCallbackList)
            if(FlxG.keys.anyJustPressed(i.keys))
                i.callback();
    }
}