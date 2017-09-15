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


class GameState extends FlxState
{
	var mouse:MouseController; 
	var newSpriteList:Array<FlxSprite> = new Array<FlxSprite>();
	var player: FlxSprite = new FlxSprite(10, 10);
	var keyboard:KeyboardController;
	var renderer:RenderBuffer;
	private var PauseSubstate:FlxSubState;

	override public function create():Void
	{
		super.create();
		mouse = new MouseController(this); 
		var text = new flixel.text.FlxText(0, 0, 0, "Play State", 64);
		text.screenCenter();
		keyboard = new KeyboardController();
		renderer = new RenderBuffer();
		//add(renderer);
		add(keyboard);
		//add(text);
		add(player); 
		player.loadGraphic(AssetPaths.player__png, true, 16, 16);
		player.animation.add("walk", [0, 1, 2, 3, 4, 5], 5, true);
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

		player.animation.play("walk");
		
		if (FlxG.keys.anyJustPressed([P, SPACE])){
			openSubState(PauseSubstate);
		}
		
		if(KeyboardController.quit()){
			//trace("quitting");
		}

		//render sprites
		while(RenderBuffer.buffer.first() != null)
		{
			var drawMe = RenderBuffer.buffer.pop();
			add(drawMe);
		}
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