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
import gameStates.GameState;
import gameObjects.Constants; 
import interfaces.Interactable; 

/**
 * The MouseController maps mouse input such that it will be read
 and modified accordingly in the update loop.
 */

class MouseController {

    public var selected:Interactable = null; 
    public var rightClicked:Bool = false; 
    public var leftClicked:Bool = false; 
    private var mouse:FlxPoint = null; 
    private var levelMap: Array<Int> = null; 
    private var prevRightClicked: Bool = false; 
    private var prevLeftClicked:Bool = false; 

    public function new(levelMap: Array<Int>):Void {
        this.levelMap = levelMap; 
    }

    public function setLevelMap(levelMap: Array<Int>):Void { 
        this.levelMap = levelMap; 
    }

    public function update(spriteList: Array<Interactable>):Void {
        var point:FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
        for (i in 0...(spriteList.length)) { 
            if (spriteList[i].overlapsPoint(point)) { 
                if (FlxG.mouse.justPressed) {
                    //set to false because it was just pressed 
                    selected = spriteList[i];
                }
                else { 
                    spriteList[i].hovered(); 
                }
                break; 
            }
        }
        //if mouse is pressed and object is at mouse location 
        if (selected != null) {
            selected.selected(mouse);
        }

        //if mouse is released and there's no object there
        if (FlxG.mouse.justReleased) {
            if (selected != null) {
                selected.released(); 
                selected = null; 
            }
        }

        prevRightClicked = rightClicked; 
        rightClicked = FlxG.mouse.justPressedRight && !prevRightClicked; 

        prevLeftClicked = leftClicked; 
        leftClicked = FlxG.mouse.justPressed && !prevLeftClicked;
    }


    //Given a point, determines whether point is 0 or 1; returns true if 0, false otherwise
    public function canPlace(): Bool {
        if (levelMap[indexClicked(FlxG.mouse.x, FlxG.mouse.y)] == 0) {
            return true; 
        }
        return false;
    }

    //Returns index in map array of tile that has been clicked 
    private function indexClicked(x: Float, y: Float):Int {  
        var numHorizTiles: Int = Math.floor(FlxG.width/Constants.TILE_WIDTH); 
        var numVertTiles: Int = Math.floor(FlxG.height/Constants.TILE_HEIGHT);
        var tileCoordX: Int = Math.floor(x/Constants.TILE_WIDTH);
        var tileCoordY: Int = Math.floor(y/Constants.TILE_HEIGHT); 
        
        return ((tileCoordY * numHorizTiles) + tileCoordX); 
    }

}