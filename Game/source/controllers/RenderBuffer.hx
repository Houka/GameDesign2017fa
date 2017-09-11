package controllers;

import flixel.FlxObject;

/**
 * The RenderBuffer gives FlxObjects an interface for spawning objects without
 * going through 
 */

class RenderBuffer
{
    static public var buffer:List<FlxObject>;

    public function new(){
        if(buffer == null){
            buffer = new List<FlxObject>();
        }
    }
}