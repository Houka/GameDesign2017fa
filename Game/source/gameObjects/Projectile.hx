package gameObjects;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.FlxG;
import interfaces.Attacker;

/***
* @author: Chang Lu
*/
@:enum
abstract ProjectileState(Int) {
  var Moving = 0;
  var Dying = 1;
}

class Projectile extends GameObject implements Attacker
{
    public var attackPoints:Int;
    public var attackType:AttackType=AttackType.Both; 
    public var attackRange:Int=0;
    public var isAttacking:Bool=true;

    public var state:ProjectileState;
    public var isEnemyProjectile:Bool;

    public function new(X:Float, Y:Float, xTarget:Float, yTarget:Float, attack:Int, speed:Float, isEnemyProjectile:Bool,
        graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(X, Y, graphicAsset,graphicsWidth,graphicsHeight);
        this.attackPoints = attack;
        this.isEnemyProjectile = isEnemyProjectile;
        centerToOrigin();

        this.angle = FlxAngle.asDegrees(FlxAngle.angleBetweenPoint(this, new FlxPoint(xTarget, yTarget)));
        velocity.set(speed, 0);
        velocity.rotate(FlxPoint.weak(0,0), this.angle);

        state = Moving;
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        if(!isOnScreen())
        {
            kill();
        }
    }
}