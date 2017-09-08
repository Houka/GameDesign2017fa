package gameStates;

import flixel.FlxState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
import flixel.math.FlxPoint;
import flixel.input.mouse.FlxMouseEventManager; 
using flixel.util.FlxSpriteUtil; 


class PlayState extends FlxState
{
	var player: FlxSprite = new FlxSprite(10, 10);
	// var pointList: Array<FlxPoint> = new Array<FlxPoint>();
	var spriteList:Array<FlxSprite> = new Array<FlxSprite>();  
	var width: Int = 32;
	var height: Int = 32; 

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

		// if (FlxG.mouse.pressed) { 
		// 	var point = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
		// 	if (isTower(point)) {
		// 		trace("pressed!");
		// 	}
		// }

		for (i in 0...(spriteList.length-1)) {
			if (FlxG.mouse.overlaps(spriteList[i])) {
				if(FlxG.mouse.pressed){
					spriteList[i].setPosition(FlxG.mouse.getPosition().x, 
						FlxG.mouse.getPosition().y); 
				}
			}
		}

		if (FlxG.mouse.justReleased) {
			var point: FlxPoint = new FlxPoint(FlxG.mouse.x, FlxG.mouse.y);
			var box = new FlxSprite(FlxG.mouse.x, FlxG.mouse.y);
			box.makeGraphic(width, height, FlxColor.GREEN, true);
			add(box);
			spriteList.push(box);
			// FlxMouseEventManager.add(box,isDragged);
			// pointList.push(point);
			// trace(pointList);
			FlxSpriteUtil.drawRoundRect(box, FlxG.mouse.x, FlxG.mouse.y, width, height, 5, 5, FlxColor.GREEN);
		}

	}

}
