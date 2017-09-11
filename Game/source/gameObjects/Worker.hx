package gameObjects;

import flixel.system.FlxAssets;
import interfaces.*;

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

	public function new(x:Int, y:Int, speed:Int, health:Int, graphicAsset:FlxGraphicAsset,?graphicsWidth:Int, ?graphicsHeight:Int): Void { 
		super(x,y,speed,health,graphicAsset,graphicsWidth,graphicsHeight);
		this.state = WorkerState.Idle;
		this.isHovered = false;
		this.isSelected = false;
	}

	public function hovered():Void{
		isHovered = true;
	}

	public function selected():Void{
		isHovered = false;
		isSelected = true;
	}

	public function released():Void{
		isSelected = false;
		isHovered = false;
	}
}
