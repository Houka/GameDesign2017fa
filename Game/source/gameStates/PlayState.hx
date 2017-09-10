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

	override public function create():Void
	{
		super.create();
		mouse = new MouseController(); 
		add(mouse);		
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

	}
}
