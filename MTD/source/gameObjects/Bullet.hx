package gameObjects;

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

import Logging;

class Bullet extends FlxSprite{
	public var attackPt:Int;
	public var type:Int;
	private var speed:Int;
	public function init(X:Int,Y:Int,Type:Int,Attack:Int,Angle:Int){
		switch (Type) {
			case 6:
				loadGraphic(AssetPaths.snowball__png,true,20,20);
				animation.add("idle",[0],10,true);
				animation.add("explode",[1,2,3,4,5],10,false);
				animation.play("idle");
			case 7:
				loadGraphic(AssetPaths.snowball2__png);
			case 8:
				loadGraphic(AssetPaths.snowball3__png);
		}

		setPosition(X-width/2,Y-height/2);
		speed = 200;
		type = Type;
		attackPt = Attack;
		angle = Angle;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0,0), angle);
		alpha = 1;
	}

	override public function kill(){
		velocity.set(0,0);
		alive = false;
		animation.play("explode");
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// get rid of off screen bullet or a too transparent bullet
		if (!isOnScreen(FlxG.camera) || alpha <= 0.8) 
		{
			kill();
		}
		
		alpha -= 0.005;

		if(!alive && animation.name=="explode" && animation.frameIndex == 4){
			super.kill();
		}
	}
}
