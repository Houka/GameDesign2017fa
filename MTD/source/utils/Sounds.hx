package utils;

import flixel.FlxG;

class Sounds{
	/*
	*	Plays sound effects
	*	Neko and html5 does not support playing mp3 files
	*/
	public static function play(filename:String, volume:Float=0.7):Void {
		FlxG.sound.play("assets/sounds/"+filename+".ogg", volume);
	}
}