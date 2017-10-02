package gameObjects.materials;

import flixel.FlxG;
import flixel.system.FlxAssets;
import interfaces.Attackable;
import interfaces.Attacker;

import controllers.TowerController; //remove me

/**
 * TowerBlock is the parent class for GunBase and Foundation.
 *
 * TODO: make mouse controls not dependent on towerController
 * @author Katherine, Chang, Yiming
 */
class TowerBlock extends Material implements Attackable
{
	public var healthPoints:Int;
	public var inTower:Bool;

	private var baseHealth:Int;

	public function new(?X:Float = 0, ?Y:Float = 0, healthPoints:Int,
		?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
	{
		super(X, Y,graphicAsset,graphicsWidth,graphicsHeight);
		this.baseHealth = healthPoints;
		this.healthPoints = healthPoints;
		inTower = false;
	}

	public function takeDamage(obj:Attacker):Void{
		if (obj.isAttacking && this.alive){
			this.healthPoints -= obj.attackPoints;
		}

		if (this.healthPoints <= 0){
			kill();
		}
	}

	override public function mouseReleasedHandler():Void{
		super.mouseReleasedHandler();
		if(!inTower){
			TowerController.installTowerBlock(this);
		}
	}
}