package gameStates;

import controllers.KeyboardController;
import controllers.RenderBuffer;
import controllers.TowerController;
import gameObjects.*;
import flixel.FlxState;
import flixel.FlxSprite; 

class PlayState extends FlxState
{
	var player: FlxSprite = new FlxSprite(10, 10);
	var keyboard:KeyboardController;
	var renderer:RenderBuffer;

	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "Play State", 64);
		text.screenCenter();
		keyboard = new KeyboardController();
		renderer = new RenderBuffer();
		add(renderer);
		add(keyboard);
		//add(text);
		add(player); 
		player.loadGraphic(AssetPaths.player__png, true, 16, 16);
		player.animation.add("walk", [0, 1, 2, 3, 4, 5], 5, true);
		var turret:TowerController = new TowerController(100, 100, 40, 50, 70);
		add(turret);
	}

	override public function update(elapsed:Float):Void
	{
		//keyboard controls 
		super.update(elapsed);
		player.animation.play("walk");
		if(KeyboardController.paused()){
			trace("paused");
		}
		if(KeyboardController.quit()){
			trace("quitting");
		}

		//render sprites
		while(RenderBuffer.buffer.first() != null)
		{
			var drawMe = RenderBuffer.buffer.pop();
			add(drawMe);
		}
	}
}
