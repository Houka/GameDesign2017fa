package gameStates;

import flixel.FlxState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
using flixel.util.FlxSpriteUtil; 


class PlayState extends FlxState
{
	var player: FlxSprite = new FlxSprite(10, 10);
	var canvas = new FlxSprite(); 


	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "Play State", 64);
		text.screenCenter();
		add(text);
		add(player); 
		player.loadGraphic(AssetPaths.player__png, true, 16, 16);
		player.animation.add("walk", [0, 1, 2, 3, 4, 5], 5, true);

		canvas.makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT, true); 
		add(canvas);

		var lineStyle:LineStyle = {color: FlxColor.BLACK, thickness: 1}; 
		var drawStyle:DrawStyle = {smoothing: true}; 
		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		player.animation.play("walk");

		if (FlxG.mouse.justReleased) {
			var box = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
			box.makeGraphic(32, 32, FlxColor.GREEN, true);
			add(box);
			FlxSpriteUtil.drawRoundRect(box, FlxG.mouse.x, FlxG.mouse.y, 32, 32, 5, 5, FlxColor.GREEN);

			// canvas.drawRect(10, 10, FlxG.mouse.x, FlxG.mouse.y, FlxColor.BLUE); 
		}
	}
}
