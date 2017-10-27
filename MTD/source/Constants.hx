package;

import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.FlxG;
import gameStates.PlayState;
import AssetPaths;


enum CursorType
{
	Normal;
	Build;
	Destroy;
}

/*
*	vars and functions used across several files
*/
class Constants{
	// Constants vars
	static public inline var MAX_HEIGHT:Int = 5;
	static public inline var HEIGHT_OFFSET:Float = 25; //the y-distance between layers
	static public inline var TILE_SIZE:Int = 64;
	static public inline var HUD_TEXT_SIZE:Int = 14;

	public static var PS:PlayState;
	
	// Constant functions
	public static function toggleCursors(Type:CursorType):Void{
		switch(Type){
			case Normal:
				FlxG.mouse.load(AssetPaths.cursor__png);
			case Build:
				FlxG.mouse.load(AssetPaths.cursor_build__png);
			case Destroy:
				FlxG.mouse.load(AssetPaths.cursor_destroy__png);
			default:
				FlxG.mouse.load(AssetPaths.cursor__png);
		}
	}

	/*
	*	Plays background music
	*	Neko and html5 does not support playing mp3 files
	*/
	public static function playMusic(filename:String):Void {
		FlxG.sound.playMusic("assets/sounds/"+filename+".ogg");
	}

	/*
	*	Plays sound effects
	*	Neko and html5 does not support playing mp3 files
	*/
	public static function play(filename:String):Void {
		FlxG.sound.play("assets/sounds/"+filename+".ogg");
	}
	
	/**
	 * The select sound gets played from a lot of places, so it's in a convenient function.
	 */
	public static function playSelectSound():Void
	{
		Constants.play("select");
	} 
}