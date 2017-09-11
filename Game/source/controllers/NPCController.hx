package controllers;

import gameObjects.NPC;
import interfaces.*;

class NPCController extends Controller<NPC>
{
	public function new():Void{
		super();
	}

	override private function updateState(obj:NPC): Void{
		switch (obj.state){
			case Idle: 
				if(obj.canMove && !obj.isAtGoal())
					obj.state = NPCState.Moving;
			case Moving: 
				var direction = obj.getDirectionToGoal();
				obj.x += direction.x*Math.min(obj.speed, obj.getDistanceToGoal().x);
				obj.y += direction.y*Math.min(obj.speed, obj.getDistanceToGoal().y);
				if(!obj.canMove || obj.isAtGoal())
					obj.state = NPCState.Idle;
		}
	}

	override private function updateAnimation(obj:NPC): Void{
		switch (obj.state){
			case Idle: obj.animation.play("idle");
			case Moving: obj.animation.play("walk");
		}
	}
}
