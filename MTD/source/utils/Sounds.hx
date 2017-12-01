package utils;

import flixel.FlxG;
import flixel.system.FlxSound;

class Sounds{
	/*
	*	Plays sound effects and manages bgm
	*	Neko and html5 does not support playing mp3 files
	*/
    private static var _currBGM:String;

	public static function play(filename:String, volume:Float=0.7):Void {
		FlxG.sound.play("assets/sounds/"+filename+".ogg", volume);
	}

    public static function playBGM(filename:String, volume:Float=0.2):Void{
        if(FlxG.sound.music == null){
            FlxG.sound.playMusic("assets/music/"+filename+".ogg", volume);
            Sounds._currBGM = filename;
        }
        else if(_currBGM != filename){
            FlxG.sound.playMusic("assets/music/"+filename+".ogg", volume);
            Sounds._currBGM = filename;
        }
    }
}