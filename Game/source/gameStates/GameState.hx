package gameStates;

import controllers.KeyboardController;
import controllers.RenderBuffer;
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
import Tile; 


class GameState extends FlxState
{
	var mouse:MouseController; 
	var newSpriteList:Array<FlxSprite> = new Array<FlxSprite>();
	var keyboard:KeyboardController;
	var renderer:RenderBuffer;
	public static var npcController:WorkerController = new WorkerController(20);
	private var PauseSubstate:FlxSubState;
	public static var map: Array<Int>; 
	public static var npcs:Array<Worker> = new Array<Worker>();
	public static var TILE_WIDTH = 60; 
	public static var TILE_HEIGHT = 60; 
	public static var SCREEN_WIDTH = 660; 
	public static var SCREEN_HEIGHT = 400; 

	override public function create():Void
	{
		super.create();
		mouse = new MouseController(this); 
		keyboard = new KeyboardController();
		renderer = new RenderBuffer();
		add(keyboard);

		map = [ 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
				0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
				0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 
				1, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0,
				1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0,
				1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0];

		createTilemap(map);

		var turret:TowerController = new TowerController(300, 200, 40, 150, 400);
		add(turret);
		var fbox:Foundation = new Foundation(50, 400, "wood", 1, 1);
		add(fbox);
		var gbox:GunBase = new GunBase(100, 400, "normal", 1, 1);
		add(gbox);
		var abox:Ammunition = new Ammunition(150, 400, "normal", 1, 1);
		add(abox);
		
		newSpriteList = [turret, fbox, gbox, abox];
		
	}

	override public function update(elapsed:Float):Void
	{
		//keyboard controls 
		super.update(elapsed);
		mouse.update(newSpriteList);
		PauseSubstate = new PauseState();
		
		if (FlxG.keys.anyJustPressed([P, SPACE])){
			openSubState(PauseSubstate);
		}
		
		if(KeyboardController.quit()){
			//trace("quitting");
		}

        testNPCUpdate();

		//render sprites
		while(RenderBuffer.buffer.first() != null)
		{
			var drawMe = RenderBuffer.buffer.pop();
			add(drawMe);
		}
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
    	var w = Std.int(SCREEN_WIDTH/TILE_WIDTH);
		var h = Std.int(SCREEN_HEIGHT/TILE_HEIGHT); 

		for (i in 0...w*h) {
			if (map[i] == 0) {
				var tile = new Tile(); 
				var x = i % w; 
				var y = Math.floor(i/w); 
				tile.setLoc(x, y); 
				add(tile);
			}
		}
	}

	//Given a point, determines whether point is 0 or 1; returns true if 0, false otherwise
	public static function canPlace(x: Float, y: Float): Bool {
		if (map[indexClicked(x,y)] == 0) {
			return true; 
		}
		return false;
	}

	//Returns index in map array of tile that has been clicked 
	public static function indexClicked(x: Float, y: Float):Int {  
		var numHorizTiles: Int = Math.floor(SCREEN_WIDTH/TILE_WIDTH); 
		var numVertTiles: Int = Math.floor(SCREEN_HEIGHT/TILE_HEIGHT);
		var tileCoordX: Int = Math.floor(x/TILE_WIDTH);
		var tileCoordY: Int = Math.floor(y/TILE_HEIGHT); 
		
		return ((tileCoordY * numHorizTiles) + tileCoordX); 
	}
}

class PauseState extends FlxSubState
{	
	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "Pause State", 64);
		text.screenCenter();
		add(text);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([P, SPACE])) {
			close();
		}
	}
	
}