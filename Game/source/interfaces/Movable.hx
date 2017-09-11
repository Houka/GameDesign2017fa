package interfaces;

import flixel.math.FlxPoint;

interface Movable
{
	public var speed:Int;
	private var goal:FlxPoint;
	public var canMove:Bool;
	public function isAtGoal():Bool;
	public function setGoal(x:Int,y:Int):Void;
	public function moveTowardGoal():Void;
}
