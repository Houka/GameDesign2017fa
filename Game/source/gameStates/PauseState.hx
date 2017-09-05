package gameStates;

import flixel.FlxState;

class PauseState extends FlxState
{
    var keyboard:KeyboardController;

	override public function create():Void
	{
		super.create();
<<<<<<< HEAD:Game/source/PlayState.hx
        keyboard = new KeyboardController();
        add(keyboard);
=======
		var text = new flixel.text.FlxText(0, 0, 0, "Pause State", 64);
		text.screenCenter();
		add(text);
>>>>>>> 11c4a459addfbb34f269d8f1dda84c3c99420fc1:Game/source/gameStates/PauseState.hx
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
        var text = new flixel.text.FlxText(0, 0, 0, "Paused", 64);
        text.screenCenter();
        add(text);

        if(KeyboardController.paused()){
            text.text = "Paused";
            //trace("Paused");
        }
        else{
            text.text = "Unpaused";
            //trace("Unpaused");
        }
	}
}
