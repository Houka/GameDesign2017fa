package gameObjects.materials;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import interfaces.Attacker;

/***
* @author: Kat
*/
@:enum
abstract GunType(Int) {
  var Normal = 0;  // + shape
  var Diagonal = 1;   // x shape
}

class GunBase extends TowerBlock
{

	public var type: GunType;    
    public var attackType:AttackType;
	public var baseAttackPoints:Int;
    public var baseAttackRange:Int;
    public var baseAttackRate:Int;

    private var _shootCooldown:Int;
	
	public function new(X:Float, Y:Float, healthPoints:Int, gunType:GunType,
		attackPoints:Int, attackType:AttackType, attackRate:Int, attackRange:Int, 
		?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
	{
		super(X, Y, healthPoints, graphicAsset, graphicsWidth, graphicsHeight);

        this.type = gunType;
        this.attackType = attackType;
        this.baseAttackPoints = attackPoints;
        this.baseAttackRate = attackRate;
        this.baseAttackRange = attackRange;
        this._shootCooldown = 0;
	}

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
        _shootCooldown++;
    }

    public function canShoot(rateMultiplier:Float):Bool
    {
        if(_shootCooldown >= baseAttackRate*rateMultiplier){
            _shootCooldown = 0;
            return true;
        }

        return false;
    }
	
}