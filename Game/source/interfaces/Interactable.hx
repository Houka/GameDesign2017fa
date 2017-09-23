package interfaces;
import flixel.math.FlxPoint;
import flixel.FlxCamera; 

interface Interactable
{
	public function hovered():Void;
	public function selected(point: FlxPoint):Void;
	public function released():Void;
	public function overlapsPoint(point:FlxPoint, InScreenSpace:Bool = false, ?Camera:FlxCamera):Bool;
}
