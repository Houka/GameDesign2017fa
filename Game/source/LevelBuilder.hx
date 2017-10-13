package; 

import sys.io.File; 
import gameObjects.mapObjects.Tile; 
import gameObjects.mapObjects.SpawnPoint; 
import gameObjects.mapObjects.HomeBase; 
import gameObjects.GameObjectFactory; 
import RenderBuffer; 


typedef JsonData = {
	var terrain_map: Array<Array<Int>>; 
    var waves: Array<Array<Int>>;
}

class LevelBuilder { 
	public function new() { 
	}


	public function parseJson(path: String) {
		var value = File.getContent(path);
		var json:JsonData = haxe.Json.parse(value); 

		createTilemap(json.terrain_map, json.waves);
	}


	public function generateLevel(path: String): Void { 
		parseJson(path); 

	}


	private function createTilemap(map: Array<Array<Int>>, waves: Array<Array<Int>>){
        for (i in 0...map.length) {
            for (j in 0...map[i].length) { 
                if (map[i][j] == 1) {
                    var tile = GameObjectFactory.createTile(j, i);
                    tile.setLocation(j, i); 
                    RenderBuffer.add(tile);
                }
                else if (map[i][j] == 2){
                    var spawnPoint = GameObjectFactory.createSpawnPoint(j*Constants.TILE_WIDTH, i*Constants.TILE_HEIGHT, waves); 
                	spawnPoint.color = 0xffaaaa;
                    RenderBuffer.add(spawnPoint);
                }
                else if (map[i][j] == 3){
                    var homeBase = GameObjectFactory.createHomeBase(j*Constants.TILE_WIDTH, i*Constants.TILE_HEIGHT); 
                    RenderBuffer.add(homeBase);
                }

                else if (map[i][j] == 0) {
                    var tile:Tile;
                    if (i+1 == map.length || map[i+1][j] != 0) 
                        tile = GameObjectFactory.createSnowTile(j, i);
                    else
                        tile = GameObjectFactory.createSnow1Tile(j, i);
                    tile.setLocation(j, i); 
                    RenderBuffer.add(tile);
                }
            }
        }
    }


}