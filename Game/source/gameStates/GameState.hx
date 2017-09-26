package gameStates;

import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSprite; 
import flixel.FlxG; 
import flixel.util.FlxColor; 
import flixel.math.FlxPoint;
import flixel.input.mouse.FlxMouseEventManager; 
import controllers.*; 
import gameObjects.GameObjectFactory;
import gameObjects.materials.GunBase;
import gameObjects.materials.Foundation;
import gameObjects.materials.TowerBlock;
import gameObjects.materials.Ammunition;
import gameObjects.mapObjects.Tile;
import gameObjects.mapObjects.SpawnPoint;
import gameObjects.mapObjects.Tower;
import gameObjects.mapObjects.HomeBase;
import gameObjects.mapObjects.Inventory;
import gameObjects.mapObjects.BuildArea;
import gameObjects.npcs.Enemy;
import interfaces.Attacker; 
using flixel.util.FlxSpriteUtil; 


class GameState extends FlxState
{
	private var controller:Controller;
	private var mouse:MouseController; 
	private var keyboard:KeyboardController;
  
	override public function create():Void
	{
		super.create();

        controller = new Controller(this);
        mouse = new MouseController(Constants.TEST_MAP);
        keyboard = new KeyboardController();
        keyboard.addKeyAndCallback([P,SPACE],function() openSubState(new PauseState()));
        keyboard.addKeyAndCallback([R],function() FlxG.switchState(new GameState()));
        keyboard.addKeyAndCallback([ESCAPE],function() FlxG.switchState(new MenuState()));

		// TODO Remove tests 
        keyboard.addKeyAndCallback([T], addTowerBlockAtMouse);
		createTilemap(Constants.TEST_MAP);	
        createStartingMaterials();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Keyboard short cut updates
		keyboard.update(elapsed);

		// Main Controller updates
		controller.update();

		// post update: empty out buffer queue and add it to state
		while(!RenderBuffer.isEmpty())
			controller.add(RenderBuffer.pop());
	}

    // TODO: Remove test function
    private function addTowerBlockAtMouse():Void{
        controller.add(GameObjectFactory.createRandomTowerBlock(FlxG.mouse.x, FlxG.mouse.y));
    }

    // TODO: remove test function
    private function createTilemap(map: Array<Int>){
        var w = Std.int(FlxG.width/Constants.TILE_WIDTH);
        var h = Std.int(FlxG.height/Constants.TILE_HEIGHT); 

        for (i in 0...w*h) {
        	var x = i % w; 
            var y = Math.floor(i/w); 
                
            if (map[i] == 1) {
            	var tile = GameObjectFactory.createTile(x,y);
                tile.setLocation(x, y); 
                controller.add(tile);
            }
            else if (map[i] == 2){
            	var spawnPoint = GameObjectFactory.createSpawnPoint(x*Constants.TILE_WIDTH, y*Constants.TILE_WIDTH);
            	spawnPoint.color = 0xff0000;
                controller.add(spawnPoint);
            }
            else if (map[i] == 3){
            	var homeBase = GameObjectFactory.createHomeBase(x*Constants.TILE_WIDTH, y*Constants.TILE_WIDTH);
            	homeBase.color = 0x0000ff;
                controller.add(homeBase);
            }
        }
    }

    // TODO: Remove test function
    private function createStartingMaterials():Void{
        controller.add(GameObjectFactory.createGunBase(100,FlxG.height*3/4));
        controller.add(GameObjectFactory.createGunBase(150,FlxG.height*3/4));
        controller.add(GameObjectFactory.createFoundation(200,FlxG.height*3/4));
        controller.add(GameObjectFactory.createFoundation(250,FlxG.height*3/4));
    }
}