 package controllers;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.math.FlxVector;
 import flixel.FlxG;
 import gameObjects.*;
 import gameStates.GameState;
 import Math.*; 

/**
 * Tower is an abstract class which provides functionality to the
 * TowerController.
 */

class TowerController extends Tower
{
    public var sight:FlxVector;

    public function new(?X:Float=0, ?Y:Float=0, rate:Int, range:Int,
        muzzle:Float, ?attack:Int=0)
    {
        super(X, Y, rate, range, muzzle, attack);
        this.sight = new FlxVector();
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
		
		if (GameState.npcs[0] != null) {
			trace(GameState.npcs[0].getX());
			for (npc in GameState.npcs) {
				sight.set(npc.getX() - x - origin.x, npc.getY() - y - origin.y);
				
				if(sight.length <= this.range) {
					this.shoot(npc.getX(), npc.getY());
					break;
				}
			}
			
		}
		
    }

    private function random(from:Int, to:Int): Int { 
        return from + Math.floor(((to - from + 1) * Math.random()));
    }
	
}