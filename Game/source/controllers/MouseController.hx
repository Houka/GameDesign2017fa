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
 * The KeyboardController maps key presses to various flags for other
 * controllers to read in sync with the update step.
 */

class MouseController extends FlxState
{
    // static private var _quit:Bool;
    // static private var _paused:Bool;

    var spriteList:Array<FlxSprite> = new Array<FlxSprite>();  
    var width: Int = 32;
    var height: Int = 32; 

    // public function new()
    // {
    //     super();
    //     _quit = false;
    //     _paused = false;
    // }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        isOverlap(); 
        mouseReleased(); 
    }

    private function mouseReleased(): Void { 
        if (FlxG.mouse.justReleased) {
            var point: FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
            var box = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
            box.makeGraphic(width, height, FlxColor.GREEN, true);
            add(box);
            spriteList.push(box);
            // FlxMouseEventManager.add(box,isDragged);
            // pointList.push(point);
            // trace(pointList);
            FlxSpriteUtil.drawRoundRect(box, FlxG.mouse.x, FlxG.mouse.y, width, height, 5, 5, FlxColor.GREEN);
        }
    }

    private function isOverlap(): Void { 
        for (i in 0...(spriteList.length-1)) {
            //don't trust this overlaps function
            if (FlxG.mouse.overlaps(spriteList[i])) {
                if(FlxG.mouse.pressed){
                    spriteList[i].setPosition(FlxG.mouse.getPosition().x, 
                        FlxG.mouse.getPosition().y); 
                }
            }
        }
    }

}