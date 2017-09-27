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
import LevelBuilder;


class GameState extends FlxState
{
	private var controller:Controller;
	private var mouse:MouseController; 
	private var keyboard:KeyboardController;
    private var levelBuilder:LevelBuilder; 
    private var level: String; 
    
    public function new(level: String):Void {
        super();
        this.level=level; 
    }

	override public function create():Void
	{
		super.create();

        controller = new Controller(this);
        mouse = new MouseController(Constants.TEST_MAP);
        keyboard = new KeyboardController();
        keyboard.addKeyAndCallback([P,SPACE],function() openSubState(new PauseState()));
        keyboard.addKeyAndCallback([R],function() FlxG.switchState(new GameState(this.level)));
        keyboard.addKeyAndCallback([ESCAPE],function() FlxG.switchState(new MenuState()));
        levelBuilder = new LevelBuilder();

		// TODO Remove tests 
        keyboard.addKeyAndCallback([T], addTowerBlockAtMouse);
        levelBuilder.generateLevel(this.level);
        createStartingMaterials();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Keyboard short cut updates
		keyboard.update(elapsed);

		// Main Controller updates
		controller.update(elapsed);

		// post update: empty out buffer queue and add it to state
		while(!RenderBuffer.isEmpty())
			controller.add(RenderBuffer.pop());
	}

    // TODO: Remove test function
    private function addTowerBlockAtMouse():Void{
        controller.add(GameObjectFactory.createRandomTowerBlock(FlxG.mouse.x, FlxG.mouse.y));
    }


    // TODO: Remove test function
    private function createStartingMaterials():Void{
        controller.add(GameObjectFactory.createGunBase(FlxG.width*3/4,100));
        controller.add(GameObjectFactory.createGunBase(FlxG.width*3/4,150));
        controller.add(GameObjectFactory.createFoundation(FlxG.width*3/4,200));
        controller.add(GameObjectFactory.createFoundation(FlxG.width*3/4,250));
    }
}