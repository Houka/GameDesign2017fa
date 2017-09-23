package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import gameObjects.GameObject;
import gameObjects.npcs.Enemy;
import interfaces.Attacker;

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
            var npc = new Enemy(this.x+this.origin.x,this.y+this.origin.y,1,10,1,2,AttackType.Ground,AssetPaths.player__png,16,16);
            npc.setGoal(400, 400);
            RenderBuffer.add(npc);
        }
    }
}