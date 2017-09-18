package gameStates;

import controllers.KeyboardController;
import views.RenderBuffer;
import controllers.TowerController;
import gameObjects.*;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
import flixel.math.FlxPoint;
import flixel.input.mouse.FlxMouseEventManager; 
using flixel.util.FlxSpriteUtil; 
import controllers.*; 


class GameState extends FlxState
{
	private var pauseSubstate:FlxSubState;
	private var controller:Controller;
	var mouse:MouseController; 
	var newSpriteList:Array<FlxSprite> = new Array<FlxSprite>();
	var keyboard:KeyboardController;
	var renderer:RenderBuffer;
	public static var npcs:Array<Worker> = new Array<Worker>();
	public static var towers:Array<Tower> = new Array<Tower>();
	private var npcController:WorkerController = new WorkerController(20);
	public var towerController:TowerController = new TowerController(60);
	public var projectileController:controllers.ProjectileController = new controllers.ProjectileController(60);
	private var PauseSubstate:FlxSubState;

	override public function create():Void
	{
		super.create();
		mouse = new MouseController(this);
		keyboard = new KeyboardController();
		renderer = new RenderBuffer();
		controller = new Controller();
		pauseSubstate = new PauseState();
		add(keyboard);
		
		// var fbox:Foundation = new Foundation(50, 400, "wood", 1, 1);
		// add(fbox);
		// var gbox:GunBase = new GunBase(100, 400, "normal", 1, 1);
		// add(gbox);
		// var abox:Ammunition = new Ammunition(150, 400, "normal", 1, 1);
		// add(abox);
		
		// newSpriteList = [fbox, gbox, abox];
		
	}

	override public function update(elapsed:Float):Void
	{
		//keyboard controls 
		super.update(elapsed);
		mouse.update(newSpriteList);
		keyboard.update(elapsed);
		controller.update();
		
		if (FlxG.keys.anyJustPressed([P, SPACE])){
			openSubState(pauseSubstate);
		}
		
		if(KeyboardController.quit()){
			//trace("quitting");
		}

		if (FlxG.mouse.justReleasedRight) {
            var npc = new Worker(FlxG.mouse.x,FlxG.mouse.y,1,10,AssetPaths.player__png,16,16);
            npc.setGoal(400, 400);
            add(npc);
            controller.addWorker(npc);
            npcs.push(npc);
        }

        testNPCUpdate();

        for(t in towers)
        {
        	towerController.update(t);
        }

		//render sprites
		while(RenderBuffer.buffer.first() != null)
		{
			var drawMe = RenderBuffer.buffer.pop();
			add(drawMe);
			if (Std.is(drawMe, gameObjects.Projectile)) {
				controller.addProjectile(cast(drawMe,gameObjects.Projectile));
			}
		}

		for(npc in npcs)
			if(!npc.exists) npcs.remove(npc);
	}

	private function testNPCUpdate():Void{
        for(npc in npcs){
            npcController.update(npc);

            //testing movement function
            if(npc.isAtGoal())
                npc.setGoal(100,100);
        }
    }

    private function createGameObjects():Void{
		// var turret:TowerController = new TowerController(300, 200, 40, 150, 400);
		// add(turret);
		
		var fbox:Foundation = new Foundation(50, 400, "wood", 1, 1);
		add(fbox);
		var gbox:GunBase = new GunBase(100, 400, "normal", 1, 1);
		add(gbox);
		var abox:Ammunition = new Ammunition(150, 400, "normal", 1, 1);
		add(abox);
		
		// newSpriteList = [turret, fbox, gbox, abox];
		newSpriteList = [fbox, gbox, abox];
    }
}