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

class MouseController 
{
    var state:FlxState; 
    var width: Int = 32;
    var height: Int = 32; 
    var selectedSprite:FlxSprite = null; 
    var wasJustReleased:Bool = false; 

    public function update(spriteList: Array<FlxSprite>):Void
    {
        //if mouse is pressed and object is at mouse location 
        if (FlxG.mouse.justPressed) {
            trace("pressed");
            //set to false because it was just pressed 
            wasJustReleased = false; 
            var point:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
            //go through sprite list and see if there is a sprite at this location
            for (i in 0...(spriteList.length)) { 
                if (spriteList[i].overlapsPoint(point)) { 
                    selectedSprite = spriteList[i];
                    break;
                }
            }
        }
        
        if (selectedSprite != null) {
                selectedSprite.setPosition(FlxG.mouse.x, FlxG.mouse.y);
        }

        //if mouse is released and there's no object there
        if (FlxG.mouse.justReleased) {
            trace("released");
            if (selectedSprite == null && !wasJustReleased) {
            // if (selectedSprite == null && !wasJustReleased) {
                var box = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y); 
                box.makeGraphic(width, height, FlxColor.GREEN, true);
                box.setGraphicSize(width, height);
                box.updateHitbox();
                state.add(box);
                spriteList.push(box);
                wasJustReleased = true; 
            }
            selectedSprite = null; 
        }
    }

    public function setState(state:FlxState): Void { 
        this.state = state; 
    }

    public function new(state:FlxState):Void {
        this.state = state; 
    }
}