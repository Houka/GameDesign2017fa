package controllers;

import gameObjects.mapObjects.Tower;
import haxe.macro.Expr;
import haxe.ds.GenericStack;
import flixel.FlxG;
import flixel.math.FlxVector;
import gameObjects.GameObject;
import gameObjects.GameObjectFactory;
import gameObjects.npcs.Enemy;
import gameObjects.npcs.Worker;
import gameObjects.mapObjects.HomeBase;

class EnemyController extends GameObjectController<Enemy>
{
	private var _sight:FlxVector;
	
	public function new(maxSize:Int=0, frameRate:Int=60):Void{
		super(maxSize, frameRate);
		_sight = new FlxVector();
	}

	override private function updateState(obj:Enemy): Void{
		super.updateState(obj);
		switch (obj.state){
			case Idle: 
				if(obj.canMove && obj.isAtGoal() && obj.walkPath.length > 0){
					var goal = obj.walkPath.shift();
					var randX= obj.walkPath.length == 0? 0 : Std.random(Constants.TILE_WIDTH)-Constants.TILE_WIDTH*2;
					var randY= obj.walkPath.length == 0? 0 : Std.random(Constants.TILE_HEIGHT)-Constants.TILE_HEIGHT*2;
					obj.setGoal(cast(goal.x+randX/4),cast(goal.y+randY/4));
				}

				if(obj.canMove && !obj.isAtGoal())
					obj.state = EnemyState.Moving;
			case Moving: 
				obj.moveTowardGoal();
				if (obj.isAttacking && obj.isAtGoal())
					obj.state = EnemyState.Attacking;
				if(!obj.canMove || obj.isAtGoal())
					obj.state = EnemyState.Idle;
			case Attacking:
				if (!obj.isAttacking)
					obj.state = EnemyState.Idle;
					trace("YES");
			case Dying:
				obj.canMove = false;
				if (Std.random(5) == 1) 
					RenderBuffer.add(GameObjectFactory.createCoin(obj.x-obj.origin.x, obj.y-obj.origin.y, Std.random(2)+1));
				obj.destroy();
		}
	}
	
	// public function canAttackTower(enemy:Enemy, tower:Tower, homebase:HomeBase):Void
 //    {
 //        _sight.set(tower.x - enemy.x - enemy.origin.x, tower.y - enemy.y - enemy.origin.y);
	// 	if (enemy.canAttack(_sight.length)) {
	// 		enemy.setGoal(Std.int(tower.x), Std.int(tower.y));
	// 		enemy.isAttacking = true;
	// 	} else {
	// 		if (enemy.isAttacking) {
	// 			enemy.setGoal(Std.int(homebase.x), Std.int(homebase.y));
	// 			enemy.isAttacking = false;
	// 		}
	// 	}
 //    }

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
	
	public function collideTower(enemy:Enemy, tower:Tower):Void {
		tower.takeDamage(enemy);
	}
}
