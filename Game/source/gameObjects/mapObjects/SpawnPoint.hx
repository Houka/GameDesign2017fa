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
	public var wavesInterval: Int = 10;
	public var _waveCountup:Int = 0;
	private var currentWave: Int = 0;
	public var finished: Bool = false;

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
			
            // trace(numEnemiesForWave(0));
			
            // // TODO: remove test code
            /*if (_enemyCountup < waves[0][0]) {
                var npc = GameObjectFactory.createEnemy(this.x+this.origin.x,this.y+this.origin.y);
                RenderBuffer.add(npc);
            }

            else if (_enemyCountup < waves[0][0] + waves[0][1]) {
                var npc = GameObjectFactory.createTank(this.x+this.origin.x,this.y+this.origin.y);
                RenderBuffer.add(npc);
            }*/
			
			if (currentWave == 0 && _enemyCountup < waves[0][currentWave]) {
				var npc = GameObjectFactory.createEnemy(this.x+this.origin.x,this.y+this.origin.y);
                RenderBuffer.add(npc);
				_enemyCountup += 1;
			}
			
			else if (currentWave == 1 && _enemyCountup < waves[0][currentWave]) {
				var npc = GameObjectFactory.createTank(this.x+this.origin.x,this.y+this.origin.y);
                RenderBuffer.add(npc);
				_enemyCountup += 1;
			}
			
			else if (_enemyCountup == waves[0][currentWave]) {
				
				if (_waveCountup == wavesInterval) {
					_enemyCountup = 0;
					currentWave += 1;
					_waveCountup = 0;
					trace(currentWave);
				}
				else if (currentWave == waves[0].length-1) {
					finished = true;
				}
				else {
					_waveCountup += 1;
				}
				
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