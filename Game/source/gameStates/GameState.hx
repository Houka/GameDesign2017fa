package gameStates;

import controllers.KeyboardController;
import controllers.TowerController;
import gameObjects.*;
import gameObjects.Tile;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
import flixel.math.FlxPoint;
import flixel.input.mouse.FlxMouseEventManager; 
using flixel.util.FlxSpriteUtil; 
import controllers.*; 
import interfaces.Interactable; 
import interfaces.Attacker; 


class GameState extends FlxState
{
	private var pauseSubstate:FlxSubState;
	private var controller:Controller;
	private var mouse:MouseController; 
	private var keyboard:KeyboardController;

	// TODO: Remove test vars
	private var towerController:TowerController = new TowerController(60);
	private var ammoType:Ammunition = new Ammunition(150, 400, "normal", 1, 1);
    private var towerPreset:List<Material> = new List<Material>();


	override public function create():Void
	{
		super.create();

		mouse = new MouseController(Constants.TEST_MAP);
		keyboard = new KeyboardController();
		controller = new Controller(this);
		pauseSubstate = new PauseState();

		// TODO Remove tests
		createTowerPresets(); 
		createTilemap(Constants.TEST_MAP);	
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Keyboard short cut updates
		keyboard.update(elapsed);
		if (KeyboardController.isPaused())
			openSubState(pauseSubstate);

		// Mouse updates
		mouse.update(controller.getInteractables());
		
		// Main Controller updates
		controller.update();

		testMouseDemo(); //TODO remove test

		// post update: empty out buffer queue and add it to state
		while(!RenderBuffer.isEmpty())
			controller.add(RenderBuffer.pop());
	}

    // TODO: remove test function... This function adds towers and enemies to the map when left and right mouse buttons are clicked
	private function testMouseDemo():Void{
		if (mouse.rightClicked) {
            var npc = new Enemy(FlxG.mouse.x,FlxG.mouse.y,1,10,1,2,AttackType.Ground,AssetPaths.player__png,16,16);
            npc.setGoal(400, 400);
            controller.add(npc);
        }

        if (mouse.leftClicked && mouse.canPlace()) {
            var turret: Tower = towerController.buildTower(towerPreset, ammoType, FlxG.mouse.x, FlxG.mouse.y);
            turret.updateHitbox();
            controller.add(turret);
        }
	}

    // TODO: remove test function
    private function createTilemap(map: Array<Int>){
        var w = Std.int(FlxG.width/Constants.TILE_WIDTH);
        var h = Std.int(FlxG.height/Constants.TILE_HEIGHT); 

        for (i in 0...w*h) {
            if (map[i] == 0) {
            	var x = i % w; 
                var y = Math.floor(i/w); 
                var tile = new Tile(x, y, TileType.Background, AssetPaths.grass__png, Constants.TILE_WIDTH, Constants.TILE_HEIGHT); 
                tile.setLocation(x, y); 
                controller.add(tile);
            }
        }
    }


    // TODO: remove test function
    private function createGameObjects():Void{
		var fbox:Foundation = new Foundation(50, 400, "wood", 1, 1);
		add(fbox);
		var gbox:GunBase = new GunBase(100, 400, "normal", 1, 1);
		add(gbox);
		var abox:Ammunition = new Ammunition(150, 400, "normal", 1, 1);
		add(abox);

		controller.add(fbox);
		controller.add(gbox);
		controller.add(abox);
    }

    // TODO: remove test function
    private function createTowerPresets(): Void { 
    	towerPreset.add(new GunBase(100, 400, "normal", 1, 1));
        towerPreset.add(new Foundation(50, 400, "wood", 1, 1));
        towerPreset.add(new Foundation(50, 400, "wood", 1, 1));
        towerPreset.add(new GunBase(100, 400, "normal", 1, 1));
    }
}