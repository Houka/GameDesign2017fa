package controllers;

import haxe.macro.Expr;
import gameObjects.Enemy;
import gameObjects.GameObject;
import gameObjects.Worker;
import flixel.FlxG;

class EnemyController extends GameObjectController<Enemy>
{
	public function new(frameRate:Int=60):Void{
		super(frameRate);
	}

	/**
	*  extraArguments = <list of terrain objs>, ?<list of workers>
	*/
	override private function updateState(obj:Enemy,?extraArguments:Array<Expr>): Void{
		super.updateState(obj,extraArguments);
		// makes sure there are extra arguments being passed in
		if (extraArguments == null){
		 	trace("Error: enemy needs <list of terrain objs>, ?<list of workers> for its update... using naive update for enemies");
		 	nativeUpdateState(obj);
		}
		else{
			smartUpdateState(obj,cast(extraArguments[0]),cast(extraArguments[1]));
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

	/** very naive and simple implementation of state switching with enemies. No path planning. */
	private function nativeUpdateState(obj:Enemy):Void{
		switch (obj.state){
			case Idle: 
				if(obj.canMove && !obj.isAtGoal())
					obj.state = EnemyState.Moving;
			case Moving: 
				obj.moveTowardGoal();
				if(!obj.canMove || obj.isAtGoal())
					obj.state = EnemyState.Idle;
			case Attacking:
			case Dying:
				obj.canMove = false;
				obj.kill();
		}
	}


	/** smarter implementation of state switching with enemies. With path planning. */
	private function smartUpdateState(obj:Enemy,terrains:Array<GameObject>,?workers:Array<Worker>):Void{
		switch (obj.state){
			case Idle: 
				if(obj.canMove && !obj.isAtGoal())
					obj.state = EnemyState.Moving;
			case Moving: 
				obj.moveTowardGoal();
				if(!obj.canMove || obj.isAtGoal())
					obj.state = EnemyState.Idle;
			case Attacking:
				for(w in workers)
					if (FlxG.collide(obj,w)) w.takeDamage(obj);
			case Dying:
				obj.canMove = false;
				obj.kill();
		}
	}
}
