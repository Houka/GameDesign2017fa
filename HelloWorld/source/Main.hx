package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	var previous:Bool; 
	var rightClicked: Bool; 
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, MenuState, 1,60,60,true,false));
	}

	public function testOptionalArg(?i:Int):Void{
		if (i==0)
			trace("optional: "+i);
	}

	public function testNestedOptionalArg(string1:String, ?i:Int):Void{
		trace("str1: "+string1);
		testOptionalArg(i);
	}
}
