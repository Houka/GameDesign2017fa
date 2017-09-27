package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import gameObjects.GameObject;
import gameObjects.npcs.Enemy;
import interfaces.Attacker;
import flixel.math.FlxPoint;
import Constants;

/**
 * SpawnPoints read the Level Data Json to create enemies as needed.
 */

class SpawnPoint extends GameObject
{
    public var spawnRate:Int;
    private var _spawnCountup:Int;

    public function new(X:Float, Y:Float, ?rate:Int=20,?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(X, Y,graphicAsset,graphicsWidth,graphicsHeight);
        this.spawnRate = rate;
        this._spawnCountup = 0;
    }

    /*For throwaway demo, just spawn a stream of basic enemies*/
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if(_spawnCountup < spawnRate)
        {
            _spawnCountup++;
        }
        else
        {
            _spawnCountup = 0;

            // TODO: remove test code
            var npc = GameObjectFactory.createEnemy(this.x+this.origin.x,this.y+this.origin.y);
            npc.walkPath = [new FlxPoint(4*Constants.TILE_WIDTH, 4*Constants.TILE_HEIGHT), new FlxPoint(8*Constants.TILE_WIDTH, 5.5*Constants.TILE_HEIGHT)]; 
            RenderBuffer.add(npc);
        }
    }
}