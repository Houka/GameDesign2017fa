package interfaces;

import flixel.math.FlxPoint;

interface Movable
{
	public var speed:Int;
	private var goalX:Int;
	private var goalY:Int;
	public var canMove:Bool;
	public function setGoal(x:Int, y:Int):Void;
	public function isAtGoal():Bool;
	public function getDistanceToGoal():FlxPoint;
	public function getDirectionToGoal():FlxPoint;
}
