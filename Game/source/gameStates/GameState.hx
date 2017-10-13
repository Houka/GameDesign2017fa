package gameStates;

#if flash
import analytics.Logging;
#end
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSprite; 
import flixel.FlxG; 
import flixel.util.FlxColor; 
import flixel.math.FlxPoint;
import flixel.input.mouse.FlxMouseEventManager; 
import controllers.*; 
import gameObjects.GameObjectFactory;
import gameObjects.materials.Material;
import gameObjects.materials.GunBase;
import gameObjects.materials.Foundation;
import gameObjects.materials.TowerBlock;
import gameObjects.materials.Ammunition;
import gameObjects.mapObjects.Tile;
import gameObjects.mapObjects.SpawnPoint;
import gameObjects.mapObjects.Tower;
import gameObjects.mapObjects.HomeBase;
import gameObjects.mapObjects.BuildArea;
import gameObjects.mapObjects.HUD;
import gameObjects.npcs.Enemy;
import interfaces.Attacker; 
import LevelBuilder;
import AssetPaths;
using flixel.util.FlxSpriteUtil; 


class GameState extends FlxState
{
    #if flash
    private var eventNum:Int;
    #end
	private var controller:Controller;
	private var mouse:MouseController; 
	private var keyboard:KeyboardController;
    private var levelBuilder:LevelBuilder; 
    private var level: String; 
    private var path:Array<FlxPoint>; 
    
    public function new(level: String, path:Array<FlxPoint>):Void {
        super();
        this.level=level; 
        this.path = path;
    }

	override public function create():Void
	{
		super.create();

        #if flash
        eventNum = 0;
        #end

        controller = new Controller(this,this.path);
        mouse = new MouseController(Constants.TEST_MAP);
        keyboard = new KeyboardController();
        keyboard.addKeyAndCallback([P, SPACE], function() openSubState(new PauseState()));
		keyboard.addKeyAndCallback([T],function() openSubState(new WinState(this.level, this.path)));
        keyboard.addKeyAndCallback([R],function() FlxG.switchState(new GameState(this.level,this.path)));
        keyboard.addKeyAndCallback([ESCAPE], function() FlxG.switchState(new MenuState()));
        levelBuilder = new LevelBuilder();

		// TODO Remove tests 
        keyboard.addKeyAndCallback([T], addTowerBlockAtMouse);

        // build level
        levelBuilder.generateLevel(this.level);

        // create HUD
        HUD.reset(Constants.PLAYER_TEST_HEALTH, 3);
        HUD.loadHealthGraphic(AssetPaths.heart__png,16,16);
        HUD.loadCurrencyGraphic(AssetPaths.coin__png,16,16);
        HUD.addHUD(this);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// Keyboard short cut updates
		keyboard.update(elapsed);

		// Main Controller updates
		controller.update(elapsed);

        //log whenever the LMB is released
        #if flash
        if(FlxG.mouse.justReleased){
            recordMouseRelease();
        }
        #end

		// post update: empty out buffer queue and add it to state
		while(!RenderBuffer.isEmpty())
			controller.add(RenderBuffer.pop());
			
		if (HUD.HEALTH <= 0) {
			openSubState(new LoseState(this.level,this.path));
		}
		if (controller.allEnemiesDead()) {
			openSubState(new WinState(this.level, this.path));
		}
	}


    // TODO: Remove test function
    private function addTowerBlockAtMouse():Void{
        controller.add(GameObjectFactory.createCoin(FlxG.mouse.x, FlxG.mouse.y,10));
    }


    //TODO: make HUD here
    // private function makeBuildArea():Void{
    //     controller.add(GameObjectFactory.createBuildArea(FlxG.width*3.1/4, FlxG.height*3.1/4));
    // } 

    private function recordMouseRelease():Void{
        #if flash
        var eventDetail:String;

        eventDetail = "["+Date.now().toString()+"] ";
        eventDetail += "x: " + FlxG.mouse.x + " ";
        eventDetail += "y: " + FlxG.mouse.y;
        Logging.getSingleton().recordEvent(eventNum, eventDetail);

        eventNum += 1;
        trace(eventDetail);
        #end
    }

    //Stop recording once this level ends
    override public function switchTo(nextState:FlxState):Bool{
        #if flash
        Logging.getSingleton().recordLevelEnd();
        #end
        return super.switchTo(nextState);
    }

}