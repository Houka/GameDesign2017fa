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

class Player extends FlxSprite{
	public var speed:Int = 100;
	private var allyRange:Int = 100;
	private var allies:FlxTypedGroup<Ally>;
	public function new(X:Int, Y:Int, allies:FlxTypedGroup<Ally>){
		super(X,Y,AssetPaths.gun1__png); // TODO: replace with player specific graphic
		this.allies = allies;
		facing = FlxObject.LEFT;
	}
	override public function update(elapsed:Float){
		super.update(elapsed);
		velocity.x=0;
		velocity.y=0;

		if (FlxG.keys.anyPressed([W,UP])){
			facing = FlxObject.UP;
			velocity.y = -speed;
		}
		if (FlxG.keys.anyPressed([S,DOWN])){
			facing = FlxObject.DOWN;
			velocity.y = speed;
		}
		if (FlxG.keys.anyPressed([A,LEFT])){
			facing = FlxObject.LEFT;
			velocity.x = -speed;
		}
		if (FlxG.keys.anyPressed([D,RIGHT])){
			facing = FlxObject.RIGHT;
			velocity.x = speed;
		}
		if (FlxG.keys.anyJustPressed([SPACE])){
			for (a in allies){
				var distance:Float = getPosition().distanceTo(a.getPosition());
				if (a.alive && !a.inTower && distance <= allyRange){
					a.facing = facing;
					a.target = null;
					break;
				}
			}
		}
	}
}