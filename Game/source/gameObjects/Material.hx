package gameObjects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import controllers.RenderBuffer;

/**
 * Material is an abstract class for Foundation, GunBase, and Ammunition.
 * 
 * TODO: Crafting/combining materials
 * 
 */
class Material extends FlxSprite
{
	public var healthPoints:Int;
	public var attackPoints:Int;
	
	public function new(?X:Float = 0, ?Y:Float = 0, healthPoints:Int, attackPoints:Int)
	{
		super(X, Y);
		this.healthPoints = healthPoints;
		this.attackPoints = attackPoints;
	}
	
	public function setHealth(health:Int): Void {
		healthPoints = health;
	}
	
	public function getHealth(): Int {
		return healthPoints;
	}
	
	public function setAttack(attack:Int): Void {
		attackPoints = attack;
	}
	
	public function getAttack(): Int {
		return attackPoints;
	}
	
	override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }
		
}