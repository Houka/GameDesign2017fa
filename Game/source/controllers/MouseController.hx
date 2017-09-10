package controllers;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
import flixel.math.FlxPoint;
import flixel.input.mouse.FlxMouseEventManager; 
using flixel.util.FlxSpriteUtil; 
import controllers.*; 

/**
 * The MouseController 
 */

class MouseController extends FlxState
{

    var spriteList:Array<FlxSprite> = new Array<FlxSprite>();  
    var width: Int = 32;
    var height: Int = 32; 

    override public function create(): Void { 
        super.create(); 
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        //if mouse is released and there's no object there
        if (FlxG.mouse.justReleased) {
            //Creates sprite 
            var box = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y); 
            box.makeGraphic(width, height, FlxColor.GREEN, true);
            add(box);
            spriteList.push(box);

        }

        //if mouse is pressed and object is at mouse location 
        if (FlxG.mouse.pressed) {
            trace("mouse is pressed"); 
            //go through sprite list and see if there is a sprite at this location
            for (i in 0...(spriteList.length - 1)) { 
                var point:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
                if (spriteList[i].overlapsPoint(point)) { 
                    spriteList[i].setPosition(FlxG.mouse.x, FlxG.mouse.y);
                    trace("there is overlap");
                }
            }
        }
    }
}