package controllers;

import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxG;

/**
 * The RenderBuffer gives FlxObjects an interface for spawning objects without
 * going through 
 */

class RenderBuffer extends FlxBasic
{
    static public var buffer:List<FlxObject>;

    public function new(){
        super();
        if(buffer == null){
            buffer = new List<FlxObject>();
        }
    }
}