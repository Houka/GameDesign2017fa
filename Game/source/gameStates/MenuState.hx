package gameStates;

import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.FlxG; 
import openfl.Lib;
import Maps; 
using Lambda; 

class MenuState extends FlxState
{
	
	override public function create():Void
	{
		super.create();

		var text = new flixel.text.FlxText(0, 0, 0, "eMpTy Defense", 50);
		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter();
		text.y -=100;
		add(text);

		var oneButton: FlxButton = new FlxButton(0, 0, "One", 
			function() {FlxG.switchState(new GameState(Maps._1,Constants.ONE_MAP));});
		oneButton.screenCenter();
		add(oneButton);

		var twoButton: FlxButton = new FlxButton(0, 0, "Two", 
			function() {FlxG.switchState(new GameState(Maps._2,Constants.EASY_MAP));});
		twoButton.screenCenter();
		twoButton.y += 25; 
		add(twoButton);

		var threeButton: FlxButton = new FlxButton(0, 0, "Three", 
			function() {FlxG.switchState(new GameState(Maps._3,Constants.THREE_MAP));});
		threeButton.screenCenter();
		threeButton.y += 50; 
		add(threeButton);

		var fourButton: FlxButton = new FlxButton(0, 0, "Four", 
			function() {FlxG.switchState(new GameState(Maps._4,Constants.EASY_MAP));});
		fourButton.screenCenter();
		fourButton.y += 75; 
		add(fourButton);

		var fiveButton: FlxButton = new FlxButton(0, 0, "Five", 
			function() {FlxG.switchState(new GameState(Maps._5,Constants.MED_MAP));});
		fiveButton.screenCenter();
		fiveButton.y += 100; 
		add(fiveButton);

		var sixButton: FlxButton = new FlxButton(0, 0, "Six", 
			function() {FlxG.switchState(new GameState(Maps._6,Constants.HARD_MAP));});
		sixButton.screenCenter();
		sixButton.y += 125; 
		add(sixButton);

		// var quitButton: FlxButton = new FlxButton(0, 0, "Quit", quitGame);
		// quitButton.screenCenter();
		// quitButton.y += 175;
		// add(quitButton);
	}

	// private function quitGame():Void 
	// {
	// 	#if !flash 
 //        	Lib.close();
 //        #end
	// }

}
