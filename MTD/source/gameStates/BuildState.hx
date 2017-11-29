package gameStates;

import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.ui.FlxBar; 
import flixel.system.FlxSound;
import openfl.Assets;
using StringTools;

import gameObjects.*;
import utils.*;

class BuildState extends FlxSubState{
	private var MAX_TOWER_HEIGHT = 3;
	private var _tower:Tower;
	private var _materials:Array<Int>;
    private var _currTowerHeight:Int;
	private var currentStack:Int;
	private var ammo:Int;
	private var ammoSprite:FlxSprite;
	private var gui:FlxTypedGroup<FlxSprite>;
	private var display:FlxTypedGroup<FlxSprite>;
	private var storePosition:FlxPoint;
	public function new(tower:Tower){
		super();
		_tower = tower;
	}
	override public function create():Void
	{
		super.create();
		currentStack = 480;
		this.ammo = 6;
		_materials = new Array<Int>();
        _currTowerHeight = 0;
		gui = new FlxTypedGroup<FlxSprite>();
		storePosition = new FlxPoint(FlxG.width - 340, 40);
		MAX_TOWER_HEIGHT = LevelData.getCurrentLevel().buildLimit;

		// semi transparent black bg overlay
		var background = new FlxSprite(Std.int(storePosition.x),0);
		background.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		background.alpha = 0.5;
		gui.add(background);

		// store bg
		var store = new FlxSprite(Std.int(storePosition.x+20),Std.int(storePosition.y));
		store.loadGraphic(AssetPaths.storewithtextnoammo__png);
		gui.add(store);

		// add buttons vars
		var gap = 10; 
		var width = 50; 
		var height = 67; 
		var x = FlxG.width-260;
		var y = 175;
		var row = 0; 
		var col = -1;
		var buttons = LevelData.getCurrentLevel().buttonTypes;
		var buildLimit = LevelData.getCurrentLevel().buildLimit; 
		var tutPos = new FlxPoint(x+col*(width+gap), y+row*(height+gap));

		// row of gun buttons
		var gun:FlxButton;
		if (buttons.indexOf(0) != -1){
			col++;
			gun = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", gunCallback.bind(0));
			gun.loadGraphic(AssetPaths.SnowyGunBase__png, true, width, height); 
			gui.add(gun);
		}

		if (buttons.indexOf(1) != -1){
			col++;
			gun = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", gunCallback.bind(1));
			gun.loadGraphic(AssetPaths.SpeedyGunBase__png, true, width, height); 
			gui.add(gun);
		}
		
		if (buttons.indexOf(2) != -1){
			col++;
			gun = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", gunCallback.bind(2));
			gun.loadGraphic(AssetPaths.SpatterGunBase__png, true, width, height); 
			gui.add(gun);
		}

		row++;
		col = -1;

		// row of foundation buttons
		var foundation:FlxButton;
		if (buttons.indexOf(3) != -1){
			col++;
			foundation = new FlxButton(x+col*(width+gap), y+row*(height+gap)+25, "", foundationCallback.bind(3));
			foundation.loadGraphic(AssetPaths.SnowBase__png, true, width, height); 
			gui.add(foundation);
		}

		if (buttons.indexOf(4) != -1){
			col++;
			foundation = new FlxButton(x+col*(width+gap), y+row*(height+gap)+25, "", foundationCallback.bind(4));
			foundation.loadGraphic(AssetPaths.IceBase__png, true, width, height); 
			gui.add(foundation);
		}
		
		if (buttons.indexOf(5) != -1){
			col++;
			foundation = new FlxButton(x+col*(width+gap), y+row*(height+gap)+25, "", foundationCallback.bind(5));
			foundation.loadGraphic(AssetPaths.CoalBase__png, true, width, height); 
			gui.add(foundation);
		}

		row++;
		col = -1;
		add(gui);

		// used for displaying the currently created tower
		display = new FlxTypedGroup<FlxSprite>();
		add(display);

		var origPlaceholderPos = Std.int(storePosition.x)+70;
		var equalsOffset = 50; 

		var equals = new FlxSprite(Std.int(storePosition.x)+159, 450); 
		equals.loadGraphic(AssetPaths.equal__png); 

		if (buildLimit >= 1){
			//add placeholder boxes 
			var placeholder = new FlxSprite(origPlaceholderPos+40, 450); 
			placeholder.loadGraphic(AssetPaths.storePlaceholder__png); 
			gui.add(placeholder); 
			gui.add(equals); 

			if (buildLimit >= 2) {
				placeholder.x = origPlaceholderPos; 
				var plus = new FlxSprite(origPlaceholderPos+29, 450); 
				plus.loadGraphic(AssetPaths.plusButton__png); 
				gui.add(plus); 

				var placeholder_2 = new FlxSprite(origPlaceholderPos+55, 450); 
				placeholder_2.loadGraphic(AssetPaths.storePlaceholder__png); 
				gui.add(placeholder_2); 

				gui.add(equals); 

				if (buildLimit >= 3) {
					var plus_2 = new FlxSprite(origPlaceholderPos+84, 450); 
					plus_2.loadGraphic(AssetPaths.plusButton__png); 
					gui.add(plus_2); 

					var placeholder_3 = new FlxSprite(Std.int(storePosition.x)+180, 450); 
					placeholder_3.loadGraphic(AssetPaths.storePlaceholder__png); 
					gui.add(placeholder_3); 

					gui.remove(equals);
					equals.x += equalsOffset; 
					gui.add(equals); 
				}
			}

		}

		// add deny and confirm buttons
		var but:FlxButton = new FlxButton(Std.int(storePosition.x) + 100, FlxG.height - 100, "", confirmedCallback);
		but.loadGraphic(AssetPaths.confirmButton__png, true, 50, 50); 
		gui.add(but);

		but = new FlxButton(Std.int(storePosition.x) +200, FlxG.height - 100, "", cancelCallback);
		but.loadGraphic(AssetPaths.denyButton__png, true, 50, 50); 
		gui.add(but);

		// tutorial related events
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 0){
			FlxG.state.remove(GameState.tutorialArrow);
			GameState.tutorialArrow.visible = true;
			GameState.tutorialArrow.setPosition(Std.int(tutPos.x)+20, Std.int(tutPos.y));
			gui.add(GameState.tutorialArrow);
			GameState.tutorialEvent++;
		}

		if (GameState.tutorialEvent == 4) { 
			FlxG.state.remove(GameState.tutorialArrow);
			GameState.tutorialArrow.visible = false;
			GameState.tutorialEvent++;
		}

		// move all gui elements outside of screen and stop their scroll factors
		var xOffset = FlxG.width;
		for (e in gui){
			e.x+=xOffset;
			e.scrollFactor.set(0,0);
		}

		// add move in tween
		for (e in gui){
			FlxTween.tween(e, { x: e.x-xOffset }, 0.5, { ease: FlxEase.expoOut });
		}
	}

	override public function add(Object:FlxBasic):FlxBasic{
		var result = super.add(Object);
		// needed to prevent camera scrolling from affecting this state
		if (Std.is(Object, FlxObject)){
			cast(Object, FlxObject).scrollFactor.set(0,0);
		}

		return result;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([Y])) {
			confirmedCallback();
		}
		if (FlxG.keys.anyJustPressed([N,P]) || (FlxG.mouse.justPressed && FlxG.mouse.x < storePosition.x)) {
			exitCallback();
		}

		// log mouse clicks
		if(FlxG.mouse.justReleased){
			var logString = "Level:"+LevelData.currentLevel+" X:"+FlxG.mouse.x+" Y:"+FlxG.mouse.y;
			Logging.recordEvent(2, logString);
		}
		if(FlxG.mouse.justPressed){
			var logString = "Level:"+LevelData.currentLevel+" X:"+FlxG.mouse.x+" Y:"+FlxG.mouse.y;
			Logging.recordEvent(1, logString);
		}
	}

	private function confirmedCallback(){
		// tutorial related
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 2){
			GameState.tutorialArrow.visible = false;
			gui.remove(GameState.tutorialArrow);
			GameState.tutorialEvent++;
		}

		Sounds.play("summon", 1);
		_materials.push(ammo);
		_tower.buildTower(_materials);

		// log tower creation and materials list
		var logString = "Level:"+LevelData.currentLevel+" X:"+_tower.x+" Y:"+_tower.y+" Materials:[";
		for(i in 0..._materials.length){
			logString+=_materials[i];
			if(i!=_materials.length-1){
				logString+=",";
			}
		}
		logString+="] Height:"+_currTowerHeight;
		Logging.recordEvent(5, logString);

		exitCallback();
	}

	private function cancelCallback(){
		Sounds.play("cancel");
		exitCallback();
	}

	private function exitCallback(){
		// reset tutorial
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent <= 2){
			gui.remove(GameState.tutorialArrow);
			FlxG.state.add(GameState.tutorialArrow);
			var tutPos = Util.toMapCoordinates(_tower.x,_tower.y);
			tutPos = Util.toCameraCoordinates(Std.int(tutPos.x - 1), Std.int(tutPos.y));
			GameState.tutorialArrow.setPosition(Std.int(tutPos.x)+GameState.tutorialArrow.width/2, 
				Std.int(tutPos.y));
			GameState.tutorialArrow.visible = true;
			GameState.tutorialEvent=0;			
		}

		for (e in display)
			FlxTween.tween(e, { x: e.x+FlxG.width }, 0.5, { ease: FlxEase.expoIn, onComplete: function(t) close() });
		for(e in gui)
			FlxTween.tween(e, { x: e.x+FlxG.width }, 0.5, { ease: FlxEase.expoIn, onComplete: function(t) close() });
	}

	private function gunCallback(type:Int){
		var tempX = Std.int(storePosition.x)+237; 

		// tutorial 
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 1){
			GameState.tutorialArrow.setPosition(Std.int(storePosition.x)+50, FlxG.height - 100);
			GameState.tutorialEvent++;
		}

		// main
        var space = 1;
		if (addMaterial(type, space)){
			var temp = new FlxSprite(tempX-40,currentStack-23);
			var gunAddition = new FlxSprite(Std.int(storePosition.x)+72+((_materials.length-1)*55)+40, 445); 
			if (LevelData.getCurrentLevel().buildLimit == 2) {
				temp = new FlxSprite(tempX-40,currentStack);
				gunAddition = new FlxSprite(Std.int(storePosition.x)+72+((_materials.length-1)*55), 445); 
			}
			else if (LevelData.getCurrentLevel().buildLimit == 3) {
				temp = new FlxSprite(tempX,currentStack);
				gunAddition = new FlxSprite(Std.int(storePosition.x)+72+((_materials.length-1)*55), 445); 
			}

			switch(type){
				case 0:
					temp.y -= 10; 
					temp.loadGraphic(AssetPaths.snowman_head__png);
					gunAddition.loadGraphic(AssetPaths.snowman_head__png); 
					gui.add(gunAddition);
				case 1:
					temp.y -= 4; 
					temp.loadGraphic(AssetPaths.snowman_machine_gun__png);
					gunAddition.loadGraphic(AssetPaths.snowman_machine_gun__png); 
					gunAddition.y += 8;
					gui.add(gunAddition);

				case 2:
					temp.y += 10;
					temp.loadGraphic(AssetPaths.snowman_spray__png);
					gunAddition.y += 10; 
					gunAddition.loadGraphic(AssetPaths.snowman_spray__png); 
					gui.add(gunAddition);
					currentStack += 10;
			}
            _currTowerHeight += space;
			currentStack -= 32;
			display.add(temp);
		}
	}
	private function foundationCallback(type:Int){
		var tempX = Std.int(storePosition.x)+237; 
		var foundationX = Std.int(storePosition.x)+72; 

        //main
        var space = MAX_TOWER_HEIGHT+1;
        switch(type){
            case 3:
                space = 1;
            case 4:
                space = 2;
            case 5:
                space = 4;
        }
		if (addMaterial(type, space)){
			var temp = new FlxSprite(tempX-40,currentStack-27);
			var foundationAddition = new FlxSprite(foundationX+((_materials.length-1)*53)+40, 453); 
			if (LevelData.getCurrentLevel().buildLimit == 2) {
				temp = new FlxSprite(tempX-40,currentStack);
				foundationAddition = new FlxSprite(foundationX+((_materials.length-1)*55), 453); 
			}
			else if (LevelData.getCurrentLevel().buildLimit == 3) {
				temp = new FlxSprite(tempX,currentStack);
				foundationAddition = new FlxSprite(foundationX+((_materials.length-1)*55), 453); 
			}

			switch(type){
				case 3:
					temp.loadGraphic(AssetPaths.snow1__png);
					foundationAddition.loadGraphic(AssetPaths.snow1__png); 
					gui.add(foundationAddition);
				case 4:
					temp.loadGraphic(AssetPaths.snowman_ice__png);
					foundationAddition.loadGraphic(AssetPaths.snowman_ice__png); 
					gui.add(foundationAddition);
				case 5:
					temp.loadGraphic(AssetPaths.snowman_coal__png);
					foundationAddition.loadGraphic(AssetPaths.snowman_coal__png); 
					gui.add(foundationAddition);
			}
            _currTowerHeight += space;
			currentStack -= 25;
			display.add(temp);
		}
	}
	private function ammoCallback(type:Int){
		switch(type){
			case 6:
				ammoSprite.loadGraphic(AssetPaths.snowball__png);
			case 7:
				ammoSprite.loadGraphic(AssetPaths.snowball2__png);
			case 8:
				ammoSprite.loadGraphic(AssetPaths.snowball3__png);
		}
		ammo = type;
	}
	private function addMaterial(type:Int, space:Int):Bool{
		if (_currTowerHeight+space <= MAX_TOWER_HEIGHT){
            Sounds.play("select");
			_materials.push(type);
			return true;
		}

		trace('cannot add more material to tower... tower already has $_materials');
		Sounds.play("deny");
		return false;
	}
}
