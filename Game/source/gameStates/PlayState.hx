package gameStates;

import flixel.FlxState;
import flixel.FlxSprite; 
import flixel.util.FlxColor; 
import flixel.FlxG; 
import flixel.math.FlxPoint;
import flixel.input.mouse.FlxMouseEventManager; 
using flixel.util.FlxSpriteUtil; 
import controllers.*; 


class PlayState extends FlxState
{
	var mouse:MouseController; 
	var newSpriteList:Array<FlxSprite> = new Array<FlxSprite>();

	override public function create():Void
	{
		super.create();
		mouse = new MouseController(this); 
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		mouse.update(newSpriteList);

	}
}
