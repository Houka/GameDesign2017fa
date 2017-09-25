package controllers;

import flixel.FlxState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
import flixel.math.FlxPoint;
import gameStates.GameState;
import interfaces.Movable;

/**
 * The MouseController maps mouse input such that it will be read
 and modified accordingly in the update loop.
 */

class MouseController {

    public var rightClicked:Bool = false; 
    public var leftClicked:Bool = false; 
    private var mouse:FlxPoint = null; 
    private var levelMap: Array<Int> = null; 
    private var prevRightClicked: Bool = false; 
    private var prevLeftClicked:Bool = false; 

    public function new(levelMap: Array<Int>):Void {
        if (FlxG.plugins.get(flixel.addons.plugin.FlxMouseControl) == null)
            FlxG.plugins.add(new flixel.addons.plugin.FlxMouseControl());
        this.levelMap = levelMap; 
        mouse = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
    }

    public function setLevelMap(levelMap: Array<Int>):Void { 
        this.levelMap = levelMap; 
    }

    public function update():Void {
        mouse = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
    }

    public function canPlace(): Bool {
        if (levelMap[indexClicked(mouse.x, mouse.y)] == 0) {
            return true; 
        }
        return false;
    }

    //Returns index in map array of tile that has been clicked 
    private function indexClicked(x: Float, y: Float):Int {  
        var numHorizTiles: Int = Math.floor(FlxG.width/Constants.TILE_WIDTH); //TODO: make this not derived from the screen size
        var numVertTiles: Int = Math.floor(FlxG.height/Constants.TILE_HEIGHT); //TODO: make this not derived from the screen size
        var tileCoordX: Int = Math.floor(x/Constants.TILE_WIDTH);
        var tileCoordY: Int = Math.floor(y/Constants.TILE_HEIGHT); 
        
        return ((tileCoordY * numHorizTiles) + tileCoordX); 
    }

}