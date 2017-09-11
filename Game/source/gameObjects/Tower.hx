 package gameObjects;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;
 import controllers.RenderBuffer;

/**
 * Tower is an abstract class which provides functionality to the
 * TowerController.
 *
 * TODO: Optimize towerStack and gunArray iteration
 */

class Tower extends FlxSprite
{
    public var fireRate:Int;
    public var range:Int;
    public var attackPoints:Int;
    public var muzzleVelocity:Float;
    private var _fireCountup:Int;

    public function new(?X:Float=0, ?Y:Float=0, rate:Int, range:Int,
        muzzle:Float, ?attack:Int=0)
    {
        super(X, Y);
        this.fireRate = rate;
        this.range = range;
        this.attackPoints = attack;
        this.muzzleVelocity = muzzle;

        this._fireCountup = 0;
        loadGraphic(AssetPaths.temp_tower__png, true, 36, 78);
        centerOffsets(true);
        centerOrigin();
        animation.add("shooting", [0,1,2,3,4,5,6,7,8,9,10], 20, false);
        animation.play("shooting");
    }

    public function shoot(xTarget:Float, yTarget:Float)
    {
        animation.play("shooting");
        if(_fireCountup>=fireRate)
        {
            trace("bang!");
            this._fireCountup = 0;
            var bullet:Projectile = new Projectile(x+origin.x, y+origin.y, xTarget, yTarget, attackPoints, muzzleVelocity);
            RenderBuffer.buffer.add(bullet);
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if(this._fireCountup < fireRate)
        {
            this._fireCountup++;
        }
    }
}
