package controllers;

import flixel.FlxState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
import flixel.math.FlxPoint;
import controllers.*; 
import gameObjects.*;
import gameStates.GameState;
import interfaces.Movable;

/**
 * The MouseController maps mouse input such that it will be read
 and modified accordingly in the update loop.
 */

class MouseController {

    var state:GameState; 
    var width:Int = 32;
    var height:Int = 32; 
    var selectedSprite:FlxSprite = null; 
    var wasJustReleased:Bool = false; 

    private var ammoType:Ammunition = new Ammunition(150, 400, "normal", 1, 1);
    private var towerPreset:List<Material> = new List<Material>();

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
                var turret:Tower = state.towerController.buildTower(towerPreset, ammoType, FlxG.mouse.x, FlxG.mouse.y);
                turret.updateHitbox();
                GameState.towers.push(turret);
                spriteList.push(turret);
                wasJustReleased = true; 
            }
            selectedSprite = null; 
        }
    }

    public function setState(state:GameState):Void { 
        this.state = state; 
    }

    public function new(state:GameState):Void {
        this.state = state; 

        towerPreset.add(new GunBase(100, 400, "normal", 1, 1));
        towerPreset.add(new Foundation(50, 400, "wood", 1, 1));
        towerPreset.add(new Foundation(50, 400, "wood", 1, 1));
        towerPreset.add(new GunBase(100, 400, "normal", 1, 1));
    }

}