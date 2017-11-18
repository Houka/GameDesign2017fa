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

class Ally extends FlxSprite{
	public var target(default,set):FlxSprite;
	public var inTower:Bool;
	private var speed:Int;
	public function init(X:Int, Y:Int, ?target:Player){
		setPosition(X,Y);
		loadGraphic(AssetPaths.snowman_machine_gun__png);
		this.target = target;
		inTower = false;
	}
	override public function update(elapsed:Float){
		super.update(elapsed);

		// reset v
		velocity.x = velocity.y = 0;

		// follow target algo
		if (target!= null && target.alive)
		{
			FlxVelocity.moveTowardsObject(this, target, speed);
		}else{
			switch (facing) {
				case FlxObject.RIGHT:
					velocity.x = speed;
				case FlxObject.LEFT:
					velocity.x = -speed;
				case FlxObject.UP:
					velocity.y = -speed;
				case FlxObject.DOWN:
					velocity.y = speed;
			 }
		}

	}
	private function set_target(Value:FlxSprite):FlxSprite{
		target = Value;
		if (target != null && Std.is(target,Player))
			speed = Std.int(cast(target,Player).speed*((Std.random(20)+75)/100.));
		return target;
	}
}