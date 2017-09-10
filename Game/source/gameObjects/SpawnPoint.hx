 package gameObjects;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * SpawnPoints read the Level Data Json to create enemies as needed.
 */

class SpawnPoint extends FlxSprite
{
    public hitPoints:Int;
    public spawnRate:Int;
    public canSpawn:Int;

    public function new(?X:Float=0, ?Y:Float=0, ?rate:Int=20;)
    {
        super(X, Y);
        this.spawnRate = rate;
        this.canSpawn = 0;
    }

    /*For throwaway demo, just spawn a stream of basic enemies*/
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if(canSpawn < spawnRate)
        {
            canSpawn++;
        }
        else
        {
            canSpawn = 0;
            //spawn();
        }
    }
}