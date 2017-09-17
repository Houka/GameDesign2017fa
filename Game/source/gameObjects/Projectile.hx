 package gameObjects;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import flixel.math.FlxAngle;
 import flixel.math.FlxPoint;
 import flixel.FlxG;

/**
 * SpawnPoints read the Level Data Json to create enemies as needed.
 */

class Projectile extends FlxSprite
{
    public var attackPoints:Int;

    public function new(?X:Float=0, ?Y:Float=0, ?xTarget:Float=0, 
        ?yTarget:Float=0, ?attack:Int=1, ?speed:Float=250)
    {
        super(X, Y);
        this.attackPoints = attack;
        loadGraphic(AssetPaths.fireball__png, false, 38, 14);
        centerOffsets(true);
        centerOrigin();
        setPosition(x-origin.x, y-origin.y);

        var pAngle = FlxAngle.asDegrees(FlxAngle.angleBetweenPoint(this, new FlxPoint(xTarget, yTarget)));
        this.angle = pAngle;
        velocity.set(speed, 0);
        velocity.rotate(FlxPoint.weak(0,0), pAngle);
    }

    /*For throwaway demo, just spawn a stream of basic enemies*/
    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if(!isOnScreen())
        {
            kill();
        }
    }
}