package controllers;

import gameObjects.GameObject;

class Controller<T>
{
	public function new(): Void{}

	public function update(obj:T): Void{
		updateState(obj);
		updateAnimation(obj);
	}

	/** These functions are meant to be abstract. Children of this class should override these functions*/
	private function updateState(obj:T): Void{}
	private function updateAnimation(obj:T): Void{}
}
