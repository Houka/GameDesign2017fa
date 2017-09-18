package controllers;

import gameObjects.GameObject;
import haxe.macro.Expr;

class GameObjectController<T>
{
	private var frameRate:Int;
	public function new(frameRate:Int=60): Void{
		this.frameRate = frameRate;
	}

	public function update(obj:T, ?extraArguments:Array<Expr>): Void{
		updateState(obj, extraArguments);
		updateAnimation(obj);
	}

	/** These functions are meant to be abstract. Children of this class should override these functions*/
	private function updateState(obj:T,?extraArguments:Array<Expr>): Void{}
	private function updateAnimation(obj:T): Void{}
	public function addAnimation(obj:T): Void{}
}
