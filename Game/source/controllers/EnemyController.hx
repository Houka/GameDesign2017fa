package controllers;

import haxe.macro.Expr;
import haxe.ds.GenericStack;
import flixel.FlxG;
import gameObjects.GameObject;
import gameObjects.GameObjectFactory;
import gameObjects.npcs.Enemy;
import gameObjects.npcs.Worker;
import gameObjects.mapObjects.HomeBase;

class EnemyController extends GameObjectController<Enemy>
{
	public function new(maxSize:Int=0, frameRate:Int=60):Void{
		super(maxSize, frameRate);
	}

	override private function updateState(obj:Enemy): Void{
		super.updateState(obj);
		switch (obj.state){
			case Idle: 
				if(obj.canMove && !obj.isAtGoal())
					obj.state = EnemyState.Moving;
			case Moving: 
				obj.moveTowardGoal();
				if(!obj.canMove || obj.isAtGoal())
					obj.state = EnemyState.Idle;
			case Attacking:
				// TODO: make attacking collision
			case Dying:
				obj.canMove = false;
				if (Std.random(2) == 1) 
					RenderBuffer.add(GameObjectFactory.createRandomTowerBlock(obj.x, obj.y));
				obj.kill();
		}
	}

	override private function updateAnimation(obj:Enemy): Void{
		super.updateAnimation(obj);
		switch (obj.state){
			case Idle: obj.animation.play("idle");
			case Moving: obj.animation.play("walk");
			case Attacking: obj.animation.play("attack");
			case Dying: obj.animation.play("idle");
		}
	}

	override public function addAnimation(obj:Enemy): Void{
		super.addAnimation(obj);

		obj.animation.add("idle", [0], frameRate, false);
		obj.animation.add("walk", [0,1,2], frameRate, true);
		obj.animation.add("attack", [0,3,6], frameRate, true);
	}


	/***********************************Collison Functions*****************************************/
	public function collideHomebase(enemy:Enemy, homeBase:HomeBase):Void{
		homeBase.takeDamage(enemy);
		enemy.kill();
	}
}