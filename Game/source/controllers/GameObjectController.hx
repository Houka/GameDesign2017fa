package controllers;

import haxe.macro.Expr;
import flixel.group.FlxGroup;
import flixel.FlxBasic;
import gameObjects.GameObject;

class GameObjectController<T:GameObject> extends FlxTypedGroup<T>
{
	private var frameRate:Int;
	public function new(maxSize:Int=0, frameRate:Int=60): Void{
		super(maxSize);
		this.frameRate = frameRate;
	}

	override public function update(elapsed:Float): Void{
		super.update(elapsed);
		forEachAlive(updateState);
		forEachExists(updateAnimation);
	}

	override public function add(obj:T):T{
		var result = super.add(obj);
		addAnimation(obj);
		return result;
	}

	/** These functions are meant to be abstract. Children of this class should override these functions*/
	private function addAnimation(obj:T): Void{}
	private function updateState(obj:T): Void{}
	private function updateAnimation(obj:T): Void{}
}
