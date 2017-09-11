package gameObjects;

import flixel.system.FlxAssets;
import interfaces.*;

/***
* @author: Chang Lu
*/
@:enum
abstract EnemyState(Int) {
  var Idle = 0;
  var Moving = 1;
  var Attacking = 2;
  var Dying = 2;
}

class Enemy extends NPC implements Attacker  
{
	public var state:EnemyState;
	public var attackPoints:Int;
	public var attackRange:Int;
	public var attackType:AttackType; 
	public var isAttacking:Bool;

	public function new(x:Int, y:Int, speed:Int, health:Int,attackPoints:Int,attackRange:Int,attackType:AttackType, 
							graphicAsset:FlxGraphicAsset,?graphicsWidth:Int, ?graphicsHeight:Int): Void { 
		super(x,y,speed,health,graphicAsset,graphicsWidth,graphicsHeight);
		this.attackPoints = attackPoints;
		this.attackRange = attackRange;
		this.attackType = attackType;
		this.isAttacking = false;
		this.state = EnemyState.Idle;
	}
}
