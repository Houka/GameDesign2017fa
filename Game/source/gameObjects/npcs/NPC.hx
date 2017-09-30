package gameObjects.npcs;

import Math.*;
import flixel.system.FlxAssets;
import interfaces.*;
import flixel.math.*;

/***
* @author: Chang Lu
*/
class NPC extends GameObject implements Attackable implements Movable implements Healable
{
	public var speed:Float;
	public var healthPoints:Int;
	public var canMove:Bool;

	private var baseHealth:Int;
	private var goal:FlxPoint;

	public function new(x:Float, y:Float, speed:Float, health:Int, graphicAsset:FlxGraphicAsset,?graphicsWidth:Int, ?graphicsHeight:Int): Void { 
		super(x,y,graphicAsset,graphicsWidth,graphicsHeight);
		this.x = x; 
		this.y = y; 
		this.speed = speed;
		this.healthPoints = health;
		this.baseHealth = health;
		this.goal = new FlxPoint(x,y);
		this.canMove = true;
		this.immovable=true;
	}
	
	public function setGoal(x:Int, y:Int):Void{
		if (this.canMove){
			this.goal.x = x;
			this.goal.y = y;
		}
	}	

	public function isAtGoal():Bool{
		return this.goal.x == this.x && this.goal.y == this.y;
	}

	public function moveTowardGoal():Void{
		var dx:Float = (this.goal.x) - this.x;
		var dy:Float = (this.goal.y) - this.y;
		var d = FlxMath.vectorLength(dx, dy);
		var a:Float = Math.atan2(dy, dx);
		var velocity:FlxPoint = new FlxPoint(Math.cos(a) * this.speed,Math.sin(a) * this.speed);
		var distance:FlxPoint = new FlxPoint(Math.cos(a) * d,Math.sin(a) * d);

		if (this.speed < d){
			this.x += velocity.x;
			this.y += velocity.y;
		}
		else{
			this.x += distance.x;
			this.y += distance.y;
		}
	}

	public function healBy(health:Int):Void{
		this.healthPoints = Std.int(Math.min(this.healthPoints+health, this.baseHealth));
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
