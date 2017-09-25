package gameStates;

import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSprite; 
import flixel.FlxG; 
import flixel.util.FlxColor; 
import flixel.math.FlxPoint;
import flixel.input.mouse.FlxMouseEventManager; 
using flixel.util.FlxSpriteUtil; 
import controllers.*; 
import gameObjects.GameObjectFactory;
import gameObjects.materials.*;
import gameObjects.mapObjects.Tile;
import gameObjects.mapObjects.SpawnPoint;
import gameObjects.mapObjects.Tower;
import gameObjects.mapObjects.HomeBase;
import gameObjects.npcs.Enemy;
import interfaces.Attacker; 


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

		// TODO Remove tests 
        keyboard.addKeyAndCallback([T], addTowerAtMouse);
		createTilemap(Constants.TEST_MAP);	
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Keyboard short cut updates
		keyboard.update(elapsed);

		// Mouse updates
		mouse.update(); // TODO: remove as we move into FlxExtendedSprite 

		// Main Controller updates
		controller.update();

		testTowerBuilding(); //TODO remove test

		// post update: empty out buffer queue and add it to state
		while(!RenderBuffer.isEmpty())
			controller.add(RenderBuffer.pop());
	}

    // TODO: remove test function... Allows for tower building but no creation of objects with mouse
    private function testTowerBuilding(){
    }

    // TODO: remove test function... This function adds towers and enemies to the map when left and right mouse buttons are clicked
	private function testMouseDemo():Void{
		if (mouse.rightClicked) {
            var npc = new Enemy(FlxG.mouse.x,FlxG.mouse.y,1,10,1,2,AttackType.Ground,AssetPaths.player__png,16,16);
            npc.setGoal(400, 400);
            controller.add(npc);
        }

        if (mouse.leftClicked && mouse.canPlace()) {
            addTowerAtMouse();
        }
	}

    private function addTowerAtMouse():Void{
        var turret: Tower = GameObjectFactory.createTower(createTowerPresets(), 
            new Ammunition(150, 400, "normal", 1, 1), FlxG.mouse.x, FlxG.mouse.y);
        turret.updateHitbox();
        controller.add(turret);        
    }

    // TODO: remove test function
    private function createTilemap(map: Array<Int>){
        var w = Std.int(FlxG.width/Constants.TILE_WIDTH);
        var h = Std.int(FlxG.height/Constants.TILE_HEIGHT); 

        for (i in 0...w*h) {
        	var x = i % w; 
            var y = Math.floor(i/w); 
                
            if (map[i] == 1) {
            	var tile = new Tile(x, y, TileType.Indestructible, 
            		AssetPaths.grass__png, Constants.TILE_WIDTH, Constants.TILE_HEIGHT); 
                tile.setLocation(x, y); 
                controller.add(tile);
            }
            else if (map[i] == 2){
            	var spawnPoint = new SpawnPoint(x*Constants.TILE_WIDTH, y*Constants.TILE_WIDTH, 100, 
            		AssetPaths.grass__png, Constants.TILE_WIDTH, Constants.TILE_HEIGHT); 
            	spawnPoint.color = 0xff0000;
                controller.add(spawnPoint);
            }
            else if (map[i] == 3){
            	var homeBase = new HomeBase(x*Constants.TILE_WIDTH, y*Constants.TILE_WIDTH, Constants.PLAYER_TEST_HEALTH, 
            		AssetPaths.grass__png, Constants.TILE_WIDTH, Constants.TILE_HEIGHT); 
            	homeBase.color = 0x0000ff;
                controller.add(homeBase);
            }
        }
    }

    // TODO: remove test function
    private function createTowerPresets(): List<Material> { 
    	var towerPreset:List<Material> = new List<Material>();
    	towerPreset.add(new GunBase(100, 400, "normal", 1, 1));
        towerPreset.add(new Foundation(50, 400, "wood", 1, 1));
        towerPreset.add(new Foundation(50, 400, "wood", 1, 1));
        towerPreset.add(new GunBase(100, 400, "normal", 1, 1));
        return towerPreset;
    }
}