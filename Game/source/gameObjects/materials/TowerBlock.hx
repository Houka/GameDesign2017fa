package gameObjects.materials;

import flixel.FlxG;
import flixel.system.FlxAssets;
import interfaces.Attackable;
import interfaces.Attacker;

/**
 * ...
 * @author ...
 */
class TowerBlock extends Material implements Attackable
{
	public var attackPoints:Int;
	public var healthPoints:Int;

	private var baseHealth:Int;

	public function new(?X:Float = 0, ?Y:Float = 0, healthPoints:Int, attackPoints:Int,
		?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
	{
		super(X, Y,graphicAsset,graphicsWidth,graphicsHeight);
		this.baseHealth = healthPoints;
		this.healthPoints = healthPoints;
		this.attackPoints = attackPoints;
	}

	public function takeDamage(obj:Attacker):Void{
		if (obj.isAttacking && this.alive){
			this.healthPoints -= obj.attackPoints;
		}

		if (this.healthPoints <= 0){
			kill();
		}
	}
}