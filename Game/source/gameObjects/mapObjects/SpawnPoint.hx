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
    private var _enemyCountup: Int = 0; 
    public var waves:Array<Array<Int>>; 

    public function new(X:Float, Y:Float, waveData: Array<Array<Int>>, ?rate:Int=20,?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(X, Y, graphicAsset,graphicsWidth,graphicsHeight);
        this.spawnRate = rate;
        this.waves = waveData; 
        this._spawnCountup = 0;
    }

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
            _enemyCountup += 1; 
            // trace(numEnemiesForWave(0)); 

            // // TODO: remove test code
            if (_enemyCountup < waves[0][0]) {
                var npc = GameObjectFactory.createEnemy(this.x+this.origin.x,this.y+this.origin.y);
                RenderBuffer.add(npc);
            }

            else if (_enemyCountup < waves[0][0] + waves[0][1]) {
                var npc = GameObjectFactory.createTank(this.x+this.origin.x,this.y+this.origin.y);
                RenderBuffer.add(npc);
            }
        }
    }

    private function numEnemiesForWave(waveNum:Int) {
        var totalEnemies: Int = 0; 
        for (i in 0...waves[waveNum].length) {
            totalEnemies += waves[waveNum][i];
        }
        return totalEnemies; 
    }


}