package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		testNestedOptionalArg("test");
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
