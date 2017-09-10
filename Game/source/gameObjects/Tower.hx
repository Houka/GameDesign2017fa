 package gameObjects;

 import flixel.FlxSprite;
 import flixel.system.FlxAssets.FlxGraphicAsset;

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
    private var _canFire:Int;

    public function new(?X:Float=0, ?Y:Float=0, rate:Int, range:Int,
        muzzle:Float, ?attack:Int=0)
    {
        super(X, Y);
        this.fireRate = rate;
        this.range = range;
        this.attackPoints = attack;
        this.muzzleVelocity = muzzle;

        this._canFire = 0;
        loadGraphic(AssetPaths.temp_tower__png, true, 36, 78);
        animation.add("shooting", [0,1,2,3,4,5,6,7,8,9,10], 20);
        animation.play("shooting");
    }

    public function shoot(xTarget:Float, yTarget:Float)
    {
        if(_canFire>=fireRate)
        {       
            this._canFire = 0;
            var ammo:Projectile = new Projectile(x, y, xTarget, yTarget, attackPoints, muzzleVelocity);
        }
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if(this._canFire < fireRate)
        {
            this._canFire++;
        }
    }
}
