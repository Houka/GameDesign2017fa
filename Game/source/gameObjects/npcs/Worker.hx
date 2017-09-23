package gameObjects.npcs;

import flixel.system.FlxAssets;
import interfaces.*;
import flixel.math.FlxPoint; 

/***
* @author: Chang Lu
*/
@:enum
abstract WorkerState(Int) {
  var Idle = 0;
  var Moving = 1;
  var Dying = 2;
}

class Worker extends NPC implements Interactable  
{
	private var isHovered:Bool;
	private var isSelected:Bool;
	public var state:WorkerState;

	public function new(x:Float, y:Float, speed:Int, health:Int, graphicAsset:FlxGraphicAsset,?graphicsWidth:Int, ?graphicsHeight:Int): Void { 
		super(x,y,speed,health,graphicAsset,graphicsWidth,graphicsHeight);
		this.state = WorkerState.Idle;
		this.isHovered = false;
		this.isSelected = false;
		this.x = x;
		this.y = y; 
	}

	public function hovered():Void{
		isHovered = true;
	}

	public function selected(point: FlxPoint):Void{
		isHovered = false;
		isSelected = true;
	}

	public function released():Void{
		isSelected = false;
		isHovered = false;
	}
}
