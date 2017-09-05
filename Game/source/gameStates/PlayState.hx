package gameStates;

import flixel.FlxState;
import flixel.FlxSprite; 

class PlayState extends FlxState
{
	var player: FlxSprite = new FlxSprite(10, 10);

	override public function create():Void
	{
		super.create();
		var text = new flixel.text.FlxText(0, 0, 0, "Play State", 64);
		text.screenCenter();
		add(text);
		add(player); 
		player.loadGraphic(AssetPaths.player__png, true, 16, 16);
		player.animation.add("walk", [0, 1, 2, 3, 4, 5], 5, true);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		player.animation.play("walk");
	}
}
