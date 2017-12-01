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
	private var ammo:Int;
	private var ammoSprite:FlxSprite;
	private var gui:FlxTypedGroup<FlxSprite>;
    private var matSlots:Array<FlxSprite>;
    private var slotSpacing:Int;
    private var buildStartPosition:FlxPoint;
	private var storePosition:FlxPoint;
	public function new(tower:Tower){
		super();
		_tower = tower;
	}
	override public function create():Void
	{
		super.create();
		this.ammo = 6;
		_materials = new Array<Int>();
        _currTowerHeight = 0;
		gui = new FlxTypedGroup<FlxSprite>();
        matSlots = new Array<FlxSprite>();
        slotSpacing = 48;
		storePosition = new FlxPoint(FlxG.width - 340, 40);
        buildStartPosition = new FlxPoint(storePosition.x+180,storePosition.y+520);
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
            gun.onOver.callback = materialButtonsHover.bind(0);
            gun.onDown.callback = materialButtonsOut;
            gun.onOut.callback = materialButtonsOut;
			gun.loadGraphic(AssetPaths.SnowyGunBase__png, true, width, height); 
			gui.add(gun);
		}

		if (buttons.indexOf(1) != -1){
			col++;
			gun = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", gunCallback.bind(1));
            gun.onOver.callback = materialButtonsHover.bind(1);
            gun.onDown.callback = materialButtonsOut;
            gun.onOut.callback = materialButtonsOut;
			gun.loadGraphic(AssetPaths.SpeedyGunBase__png, true, width, height); 
			gui.add(gun);
		}
		
		if (buttons.indexOf(2) != -1){
			col++;
			gun = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", gunCallback.bind(2));
            gun.onOver.callback = materialButtonsHover.bind(2);
            gun.onDown.callback = materialButtonsOut;
            gun.onOut.callback = materialButtonsOut;
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
            foundation.onOver.callback = materialButtonsHover.bind(3);
            foundation.onDown.callback = materialButtonsOut;
            foundation.onOut.callback = materialButtonsOut;
			foundation.loadGraphic(AssetPaths.SnowBase__png, true, width, height); 
			gui.add(foundation);
		}

		if (buttons.indexOf(4) != -1){
			col++;
			foundation = new FlxButton(x+col*(width+gap), y+row*(height+gap)+25, "", foundationCallback.bind(4));
            foundation.onOver.callback = materialButtonsHover.bind(4);
            foundation.onDown.callback = materialButtonsOut;
            foundation.onOut.callback = materialButtonsOut;
			foundation.loadGraphic(AssetPaths.IceBase__png, true, width, height); 
			gui.add(foundation);
		}
		
		if (buttons.indexOf(5) != -1){
			col++;
			foundation = new FlxButton(x+col*(width+gap), y+row*(height+gap)+25, "", foundationCallback.bind(5));
            foundation.onOver.callback = materialButtonsHover.bind(5);
            foundation.onDown.callback = materialButtonsOut;
            foundation.onOut.callback = materialButtonsOut;
			foundation.loadGraphic(AssetPaths.CoalBase__png, true, width, height); 
			gui.add(foundation);
		}

		row++;
		col = -1;
		add(gui);

		//add the material slots in the build area
        for(i in 0...MAX_TOWER_HEIGHT){
            var slot = new FlxSprite(buildStartPosition.x,buildStartPosition.y-(i*slotSpacing));
            slot.loadGraphic(AssetPaths.material_sockets__png, true, 48, 48);
            slot.x -= slot.origin.x;
            slot.y -= slot.origin.y;
            matSlots.push(slot);
            gui.add(slot);
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

    //translate type to spaces
    private function getSpaces(type:Int):Int{
        switch(type){
            case 3:
                return 1;
            case 4:
                return 2;
            case 5:
                return 4;
            default:
                return 1;
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

		for(e in gui)
			FlxTween.tween(e, { x: e.x+FlxG.width }, 0.5, { ease: FlxEase.expoIn, onComplete: function(t) close() });
	}

	private function gunCallback(type:Int){
		// tutorial 
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 1){
			GameState.tutorialArrow.setPosition(Std.int(storePosition.x)+50, FlxG.height - 100);
			GameState.tutorialEvent++;
		}

		// main
        var iconOffset = 32;
		if (addMaterial(type)){
			var gunAddition = new FlxSprite(buildStartPosition.x,buildStartPosition.y-(_currTowerHeight*slotSpacing)); 

            var swordIcon = new FlxSprite(buildStartPosition.x+iconOffset,buildStartPosition.y-(_currTowerHeight*slotSpacing));
            swordIcon.loadGraphic(AssetPaths.sword__png,true,16,16);
            swordIcon.animation.add("shining",[0,1,2,3],10,true);
            swordIcon.animation.play("shining");

			switch(type){
				case 0:
					gunAddition.loadGraphic(AssetPaths.snowman_head__png);
                    gunAddition.x -= gunAddition.origin.x;
                    gunAddition.y -= gunAddition.origin.y;
                    gui.add(gunAddition);
                    gui.add(swordIcon);
				case 1:
					gunAddition.loadGraphic(AssetPaths.snowman_machine_gun__png);
                    gunAddition.x -= gunAddition.origin.x;
                    gunAddition.y -= gunAddition.origin.y;
                    gui.add(gunAddition);
                    gui.add(swordIcon);
				case 2:
					gunAddition.loadGraphic(AssetPaths.snowman_spray__png);
                    gunAddition.x -= gunAddition.origin.x;
                    gunAddition.y -= gunAddition.origin.y;
                    gui.add(gunAddition);
                    gui.add(swordIcon);
			}
            _currTowerHeight += 1;
		}
	}

    private function materialButtonsHover(type:Int){
        if(_currTowerHeight+getSpaces(type)<=MAX_TOWER_HEIGHT){
            for(i in _currTowerHeight...getSpaces(type)+_currTowerHeight){
                matSlots[i].animation.frameIndex = 1;
            }
        }
        else{ //not enough room
            for(i in _currTowerHeight...matSlots.length){
                matSlots[i].animation.frameIndex = 2;
            }
        }
    }

    private function materialButtonsOut(){
        for(i in _currTowerHeight...matSlots.length){
            matSlots[i].animation.frameIndex = 0;
        }
    }

	private function foundationCallback(type:Int){
        //main
        var iconOffset = 40;
        var heartOffset = 16;
		if (addMaterial(type)){
			var foundationAddition = new FlxSprite(buildStartPosition.x,buildStartPosition.y-(_currTowerHeight+getSpaces(type)-1)*slotSpacing);

			switch(type){
				case 3:
					foundationAddition.loadGraphic(AssetPaths.snow1__png);
                    foundationAddition.x -= foundationAddition.origin.x;
                    foundationAddition.y -= foundationAddition.origin.y;
					gui.add(foundationAddition);
                    for(i in 0...1){
                        var healthIcon = new FlxSprite(buildStartPosition.x-iconOffset-(i*heartOffset),buildStartPosition.y-(_currTowerHeight+getSpaces(type)-1)*slotSpacing);
                        healthIcon.loadGraphic(AssetPaths.heart__png,true,16,16);
                        healthIcon.animation.add("beating",[0,1,2,1,0,0,0,0,0,0,0],10,true);
                        healthIcon.animation.play("beating");
                        gui.add(healthIcon);
                    }
				case 4:
					foundationAddition.loadGraphic(AssetPaths.snowman_ice__png); 
                    foundationAddition.x -= foundationAddition.origin.x;
                    foundationAddition.y -= foundationAddition.origin.y;
                    gui.add(foundationAddition);
                    for(i in 0...3){
                        var healthIcon = new FlxSprite(buildStartPosition.x-iconOffset-(i*heartOffset),buildStartPosition.y-(_currTowerHeight+getSpaces(type)-1)*slotSpacing);
                        healthIcon.loadGraphic(AssetPaths.heart__png,true,16,16);
                        healthIcon.animation.add("beating",[0,1,2,1,0,0,0,0,0,0,0],10,true);
                        healthIcon.animation.play("beating");
                        gui.add(healthIcon);
                    }
				case 5:
					foundationAddition.loadGraphic(AssetPaths.snowman_coal__png); 
                    foundationAddition.x -= foundationAddition.origin.x;
                    foundationAddition.y -= foundationAddition.origin.y;
                    gui.add(foundationAddition);
                    for(i in 0...7){
                        var healthIcon = new FlxSprite(buildStartPosition.x-iconOffset-(i*heartOffset),buildStartPosition.y-(_currTowerHeight+getSpaces(type)-1)*slotSpacing);
                        healthIcon.loadGraphic(AssetPaths.heart__png,true,16,16);
                        healthIcon.animation.add("beating",[0,1,2,1,0,0,0,0,0,0,0],10,true);
                        healthIcon.animation.play("beating");
                        gui.add(healthIcon);
                    }
			}
            //grey out additional spaces the foundation takes up
            for(i in _currTowerHeight..._currTowerHeight+getSpaces(type)-1){
                matSlots[i].animation.frameIndex = 2;
            }
            _currTowerHeight += getSpaces(type);
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
	private function addMaterial(type:Int):Bool{
		if (_currTowerHeight+getSpaces(type) <= MAX_TOWER_HEIGHT){
            Sounds.play("select");
			_materials.push(type);
			return true;
		}

		trace('cannot add more material to tower... tower already has $_materials');
		Sounds.play("deny");
		return false;
	}
}
