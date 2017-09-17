//https://gamedevelopment.tutsplus.com/tutorials/an-introduction-to-creating-a-tile-map-engine--gamedev-10900

import flixel.FlxSprite;
import gameStates.GameState; 

class Tile extends FlxSprite {
	
	public function new() {
		super(); 

		loadGraphic(AssetPaths.grass__png, true, 60, 60);

	}

	public function setLoc(x:Int, y:Int) {
		this.x = x * GameState.TILE_WIDTH; 
		this.y = y * GameState.TILE_HEIGHT;
	}

}