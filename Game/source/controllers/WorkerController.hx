package controllers;

import haxe.macro.Expr;
import gameObjects.npcs.Worker;

class WorkerController extends GameObjectController<Worker>
{
	public function new(frameRate:Int=60):Void{
		super(frameRate);
	}

	override private function updateState(obj:Worker): Void{
		super.updateState(obj);
		switch (obj.state){
			case Idle: 
				if(obj.canMove && !obj.isAtGoal())
					obj.state = WorkerState.Moving;
			case Moving: 
				obj.moveTowardGoal();
				if(!obj.canMove || obj.isAtGoal())
					obj.state = WorkerState.Idle;
			case Dying:
				obj.canMove = false;
				obj.kill();
		}
	}

	override private function updateAnimation(obj:Worker): Void{
		super.updateAnimation(obj);
		switch (obj.state){
			case Idle: obj.animation.play("idle");
			case Moving: obj.animation.play("walk");
			case Dying: obj.animation.play("idle");
		}
	}

	override public function addAnimation(obj:Worker): Void{
		super.addAnimation(obj);

		obj.animation.add("idle", [0], frameRate, false);
		obj.animation.add("walk", [0,1,2], frameRate, true);
	}
}
