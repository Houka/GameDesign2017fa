package gameObjects; 

import gameStates.GameState; 
import flixel.system.FlxAssets;
import gameObjects.Constants;
import flixel.math.FlxPoint;


class Tile extends GameObject implements interfaces.Interactable {
	
	public function new(x: Float, y: Float, graphicAsset: FlxGraphicAsset, ?graphicsWidth: Int, ?graphicsHeight: Int) {
		super(x, y, graphicAsset, graphicsWidth, graphicsHeight); 
	}

	public function setLocation(x:Int, y:Int) {
		this.x = x * Constants.TILE_WIDTH; 
		this.y = y * Constants.TILE_HEIGHT;
	}

	public function hovered():Void {

	}
	public function selected(point: FlxPoint):Void {

	}
	public function released():Void{

	}

}