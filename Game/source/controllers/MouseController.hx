package controllers;

import flixel.FlxState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
import flixel.math.FlxPoint;
import controllers.*; 
import gameObjects.*; 
import interfaces.Movable;

/**
 * The MouseController maps mouse input such that it will be read
 and modified accordingly in the update loop.
 */

class MouseController {

    var state:FlxState; 
    var width:Int = 32;
    var height:Int = 32; 
    var selectedSprite:FlxSprite = null; 
    var wasJustReleased:Bool = false; 


    public function update(spriteList: Array<FlxSprite>):Void {
        //if mouse is pressed and object is at mouse location 
        if (FlxG.mouse.justPressed) {
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
            if (selectedSprite == null && !wasJustReleased) {
                var turret:TowerController = new TowerController(FlxG.mouse.x, FlxG.mouse.y, 40, 150, 400, 5);
                turret.updateHitbox();
                state.add(turret);
                spriteList.push(turret);
                wasJustReleased = true; 
            }
            selectedSprite = null; 
        }
    }

    public function setState(state:FlxState):Void { 
        this.state = state; 
    }

    public function new(state:FlxState):Void {
        this.state = state; 
    }

}