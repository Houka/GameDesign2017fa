 package gameObjects;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;

/**
 * SpawnPoints read the Level Data Json to create enemies as needed.
 */

class SpawnPoint extends FlxSprite
{
    public spawnRate:Int;
    private _spawnCountup:Int;

    public function new(?X:Float=0, ?Y:Float=0, ?rate:Int=20;)
    {
        super(X, Y);
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
            //spawn();
        }
    }
}