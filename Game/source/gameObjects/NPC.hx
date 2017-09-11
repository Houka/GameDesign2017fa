package gameObjects;

import Math.*;
import flixel.system.FlxAssets;
import interfaces.*;
import flixel.math.FlxPoint;

/***
* @author: Chang Lu
*/
@:enum
abstract NPCState(Int) {
  var Idle = 0;
  var Moving = 1;
}

class NPC extends GameObject implements Attackable implements Movable implements Healable
{
	var baseHealth:Int;
	var goalX:Int;
	var goalY:Int;
	public var speed:Int;
	public var healthPoints:Int;
	public var isDead:Bool;
	public var canMove:Bool;
	public var state:NPCState;

	public function new(x:Int, y:Int, speed:Int, health:Int, graphicAsset:FlxGraphicAsset,?graphicsWidth:Int, ?graphicsHeight:Int): Void { 
		super(x,y,graphicAsset,graphicsWidth,graphicsHeight);
		this.speed = speed;
		this.healthPoints = health;
		this.baseHealth = health;
		this.isDead = false;
		this.goalX = x;
		this.goalY = y;
		this.canMove = true;
		this.state = NPCState.Idle;
	}

	public function takeDamage(obj:Attacker):Void{
		if (obj.isAttacking() && !this.isDead){
			this.health -= obj.attackPoints;
		}

		if (this.health <= 0){
			this.isDead == true;
		}
	}
	
	public function setGoal(x:Int, y:Int):Void{
		if (this.canMove){
			this.goalX = x;
			this.goalY = y;
		}
	}	

	public function isAtGoal():Bool{
		return this.goalX == this.x && this.goalY == this.y;
	}

	public function getDistanceToGoal():FlxPoint{
		return new FlxPoint(Math.abs(this.goalX - this.x),Math.abs(this.goalY - this.y));
	}

	public function getDirectionToGoal():FlxPoint{
		var x = 0;
		var y = 0;
		if (this.x-this.goalX > 0)
			x = -1;
		else if (this.x-this.goalX < 0)
			x = 1;

		if (this.y-this.goalY > 0)
			y = -1;
		else if (this.y-this.goalY < 0)
			y = 1;

		return new FlxPoint(x,y);
	}

	public function healBy(health:Int):Void{
		this.health = min(this.health+health, this.baseHealth);
	}

}
