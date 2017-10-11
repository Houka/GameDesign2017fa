package gameStates;

import flixel.FlxSubState;
import flixel.FlxG;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.math.FlxPoint;

class WinState extends FlxSubState
{	
	private var level: String; 
    private var path:Array<FlxPoint>; 
	
	public function new(level: String, path:Array<FlxPoint>):Void {
        super();
        this.level=level; 
        this.path = path;
    }
	
	override public function create():Void
	{
		super.create();
		
		var text = new flixel.text.FlxText(0, 0, 0, "Win State", 50);
		text.alignment = FlxTextAlign.CENTER;
		text.screenCenter();
		text.y -=100;
		add(text);
		
		var replayButton: FlxButton = new FlxButton(0, 0, "Replay Level", 
			function() {FlxG.switchState(new GameState(this.level,this.path));});
		replayButton.screenCenter();
		add(replayButton);

		// TODO: Set button to next level from current
		var nextLevelButton: FlxButton = new FlxButton(0, 0, "Next Level", 
			function() {FlxG.switchState(new GameState(AssetPaths.medMap__json,Constants.MED_MAP));});
		nextLevelButton.screenCenter();
		nextLevelButton.y += 50; 
		add(nextLevelButton);

		var menuButton: FlxButton = new FlxButton(0, 0, "Menu", 
			function() {FlxG.switchState(new MenuState());});
		menuButton.screenCenter();
		menuButton.y += 100; 
		add(menuButton);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}	
}