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
import interfaces.Interactable; 


class GameState extends FlxState
{
	private var pauseSubstate:FlxSubState;
	private var controller:Controller;
	var mouse:MouseController; 
	var newSpriteList:Array<FlxSprite> = new Array<FlxSprite>();
	var keyboard:KeyboardController;
	var renderer:RenderBuffer;

	public static var npcController:WorkerController = new WorkerController(20);
	public static var npcs:Array<Worker> = new Array<Worker>();
	public static var towers:Array<Tower> = new Array<Tower>();
	public var towerController:TowerController = new TowerController(60);
	private var PauseSubstate:FlxSubState;
	private var ammoType:Ammunition = new Ammunition(150, 400, "normal", 1, 1);
    private var towerPreset:List<Material> = new List<Material>();


	override public function create():Void
	{
		super.create();

		var map = [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
					0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 
					1, 1, 0, 0, 0, 1, 0, 1, 0, 1,
					1, 1, 0, 0, 0, 0, 0, 0, 0, 0,
					1, 1, 0, 0, 0, 0, 0, 0, 0, 0];

		mouse = new MouseController(map);
		keyboard = new KeyboardController();
		renderer = new RenderBuffer();
		controller = new Controller();
		pauseSubstate = new PauseState();
		add(keyboard);
		createTowerPresets(); 
		createTilemap(map);	
	}

	override public function update(elapsed:Float):Void
	{
		//keyboard controls 
		super.update(elapsed);
		var interactables: Array<Interactable> = []; 
		for (i in 0...newSpriteList.length) {
			if (Std.is(newSpriteList[i], Interactable)) {
				interactables.push(cast(newSpriteList[i], Interactable));
			}
		}
		mouse.update(interactables);
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

        if (mouse.leftClicked && mouse.canPlace()) {

            var turret: Tower = towerController.buildTower(towerPreset, ammoType, FlxG.mouse.x, FlxG.mouse.y);
            turret.updateHitbox();
            towers.push(turret);
            newSpriteList.push(turret);
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

    private function createTilemap(map: Array<Int>){
        var w = Std.int(FlxG.width/Constants.TILE_WIDTH);
        var h = Std.int(FlxG.height/Constants.TILE_HEIGHT); 

        for (i in 0...w*h) {
            if (map[i] == 0) {
            	var x = i % w; 
                var y = Math.floor(i/w); 
                var tile = new Tile(x, y, AssetPaths.grass__png, Constants.TILE_WIDTH, Constants.TILE_HEIGHT); 
                tile.setLocation(x, y); 
                add(tile);
            }
        }
    }



    private function createGameObjects():Void{
		var fbox:Foundation = new Foundation(50, 400, "wood", 1, 1);
		add(fbox);
		var gbox:GunBase = new GunBase(100, 400, "normal", 1, 1);
		add(gbox);
		var abox:Ammunition = new Ammunition(150, 400, "normal", 1, 1);
		add(abox);
		
		newSpriteList = [fbox, gbox, abox];
    }

    private function createTowerPresets(): Void { 
    	towerPreset.add(new GunBase(100, 400, "normal", 1, 1));
        towerPreset.add(new Foundation(50, 400, "wood", 1, 1));
        towerPreset.add(new Foundation(50, 400, "wood", 1, 1));
        towerPreset.add(new GunBase(100, 400, "normal", 1, 1));
    }
}