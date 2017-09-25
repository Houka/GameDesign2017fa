package gameObjects.mapObjects; 

import gameStates.GameState; 
import flixel.system.FlxAssets;
import flixel.math.FlxPoint;


@:enum
abstract TileType(Int) {
  var Background = 0;
  var Indestructible = 1;
  var Destructible = 2;
}

class Tile extends GameObject{

	public var type:TileType;
	
	public function new(x: Float, y: Float, type:TileType, graphicAsset: FlxGraphicAsset, ?graphicsWidth: Int, ?graphicsHeight: Int) {
		super(x, y, graphicAsset, graphicsWidth, graphicsHeight); 
		this.type = type;
		this.immovable=true;
		enableInteractable();
	}

	public function setLocation(x:Int, y:Int) {
		this.x = x * Constants.TILE_WIDTH; 
		this.y = y * Constants.TILE_HEIGHT;
	}
}