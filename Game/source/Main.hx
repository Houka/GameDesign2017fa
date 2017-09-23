package;

import flixel.FlxGame;
import openfl.display.Sprite;
import gameStates.*;  
import controllers.*;
import gameObjects.*;
import haxe.Timer; 
import flixel.FlxG; 

class Main extends Sprite
{
	public function new()
	{
		super();
		removeHTML5ContextMenu();
		addChild(new FlxGame(0, 0, LoadingState, 1,60,60,true,false));
	}

	public function removeHTML5ContextMenu():Void{
		#if js
		untyped {
			document.oncontextmenu = document.body.oncontextmenu = function() {return false;}
		}
		#end
	}
}
