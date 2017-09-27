package; 

import sys.io.File; 
import gameObjects.mapObjects.Tile; 
import gameObjects.mapObjects.SpawnPoint; 
import gameObjects.mapObjects.HomeBase; 
import RenderBuffer; 


typedef JsonData = {
	var terrain_map: Array<Array<Int>>; 
}

class LevelBuilder { 
	public function new() { 
	}


	public function parseJson(path: String) {
		var value = File.getContent(path);
		var json:JsonData = haxe.Json.parse(value); 

		createTilemap(json.terrain_map);
	}


	public function generateLevel(path: String): Void { 
		parseJson(path); 

	}


	private function createTilemap(map: Array<Array<Int>>){
        for (i in 0...map.length) {
            for (j in 0...map[i].length) { 
                if (map[i][j] == 1) {
                	var tile = new Tile(j, i, TileType.Indestructible, 
                		AssetPaths.grass__png, Constants.TILE_WIDTH, Constants.TILE_HEIGHT); 
                    tile.setLocation(j, i); 
                    RenderBuffer.add(tile);
                }
                else if (map[i][j] == 2){
                	var spawnPoint = new SpawnPoint(j*Constants.TILE_WIDTH, i*Constants.TILE_WIDTH, 100, 
                		AssetPaths.grass__png, Constants.TILE_WIDTH, Constants.TILE_HEIGHT); 
                	spawnPoint.color = 0xff0000;
                    RenderBuffer.add(spawnPoint);
                }
                else if (map[i][j] == 3){
                	var homeBase = new HomeBase(j*Constants.TILE_WIDTH, i*Constants.TILE_WIDTH, Constants.PLAYER_TEST_HEALTH, 
                		AssetPaths.grass__png, Constants.TILE_WIDTH, Constants.TILE_HEIGHT); 
                	homeBase.color = 0x0000ff;
                    RenderBuffer.add(homeBase);
                }
            }
        }
    }


}