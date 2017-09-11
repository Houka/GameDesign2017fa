package controllers;

import gameObjects.GameObject;

class GameObjectController<T>
{
	private var frameRate:Int;
	public function new(frameRate:Int=60): Void{
		this.frameRate = frameRate;
	}

	public function update(obj:T): Void{
		updateState(obj);
		updateAnimation(obj);
	}

	/** These functions are meant to be abstract. Children of this class should override these functions*/
	private function updateState(obj:T): Void{}
	private function updateAnimation(obj:T): Void{}
	public function addAnimation(obj:T): Void{}
}
