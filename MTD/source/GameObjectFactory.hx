package;

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
import flixel.input.mouse.FlxMouseEventManager;
import openfl.Assets;
using StringTools;

import gameObjects.*;
import utils.*;

class GameObjectFactory{
	public static var dummyAlly = new Ally();
	public static function addEnemy(enemies:FlxTypedGroup<Enemy>, X:Int, Y:Int, Type:Int, Path:Array<FlxPoint>):Enemy{
		var enemy = enemies.recycle(Enemy);	// uses an already added enemy, or makes a new one and adds it to enemies

		var _framerate:Int = 13;
		//set up cookie clicker interaction
		FlxMouseEventManager.add(enemy, enemy.chipDmg);
		// make enemy based on type
		switch (Type) {	
			case 0:
				enemy.init(X,Y,Type,1,3,100,Path);
				enemy.loadGraphic(AssetPaths.snowball_spritesheet__png, true, 64, 64);
				enemy.animation.add("idle",[0],_framerate, true);

				enemy.animation.add("walk_down",[16,17,18,19,20,21,22,23],_framerate, true);
				enemy.animation.add("attack_down",[16,17,18,19,20,21,22,23],_framerate, true);

				enemy.animation.add("walk_left",[24,25,26,27,28,29,30,31],_framerate, true);
				enemy.animation.add("attack_left",[24,25,26,27,28,29,30,31],_framerate, true);

				enemy.animation.add("walk_right",[0,1,2,3,4,5,6,7],_framerate, true);
				enemy.animation.add("attack_right",[0,1,2,3,4,5,6,7],_framerate, true);

				enemy.animation.add("walk_up",[8,9,10,11,12,13,14,15],_framerate, true);
				enemy.animation.add("attack_up",[8,9,10,11,12,13,14,15],_framerate, true);
			case 1:
				enemy.init(X,Y,Type,1,4,150,Path);
				enemy.loadGraphic(AssetPaths.kid_ss__png, true, 64, 64);
				enemy.animation.add("idle",[8],_framerate, true);

				enemy.animation.add("walk_down",[32,33,34,35,36,37,38,39],_framerate, true);
				enemy.animation.add("attack_down",[40,41,42,43,44,45],6,true); 

				enemy.animation.add("walk_left",[48,49,50,51,52,53,54,55],_framerate, true);
				enemy.animation.add("attack_left",[56,57,58,59,60],5,true);
				
				enemy.animation.add("walk_right",[0,1,2,3,4,5,6,7],_framerate, true);
				enemy.animation.add("attack_right", [8,9,10,11,12],5, true);
				
				enemy.animation.add("walk_up",[16,17,18,19,20,21,22,23],_framerate, true);
				enemy.animation.add("attack_up",[24,25,26,27,28],5,true);

				// enemy.animation.add("attack",[32,33,34,35,36,37], 5, true);
			case 2:
				enemy.init(X,Y,Type,2,12,50,Path);
				enemy.loadGraphic(AssetPaths.gal_ss__png, true, 64, 64);
				enemy.animation.add("idle",[8],_framerate, true);

				enemy.animation.add("walk_down",[24,25,26,27,28,29],_framerate, true);
				enemy.animation.add("attack_down",[30,31,32,33,34,35],_framerate,true); 

				enemy.animation.add("walk_left",[36,37,38,39,40,41],_framerate, true);
				enemy.animation.add("attack_left",[42,43,44,45,46,47],_framerate,true);
				
				enemy.animation.add("walk_right",[0,1,2,3,4,5],_framerate, true);
				enemy.animation.add("attack_right", [6,7,8,9,10,11],_framerate, true);
				
				enemy.animation.add("walk_up",[12,13,14,15,16,17],_framerate, true);
				enemy.animation.add("attack_up",[18,19,20,21,22,23],_framerate,true);

				// enemy.animation.add("attack",[32,33,34,35,36,37], 5, true);
			default:
				trace('No such enemy type: $Type');
		}

		return enemy;
	}

	public static function addTower(towers:FlxTypedGroup<Tower>, X, Y, bullets:FlxTypedGroup<Bullet>, 
									towerLayers:FlxTypedGroup<FlxSprite>, map:FlxTilemap):Tower{
		var tower = towers.recycle(Tower);
		var point = Util.toCameraCoordinates(X,Y);
		tower.init(Std.int(point.x), Std.int(point.y),bullets,towerLayers,map);

		return tower;
	}

	public static function addAlly(allies:FlxTypedGroup<Ally>, X:Int, Y:Int, ?player:Player):Ally{
		var ally = allies.recycle(Ally);
		ally.init(X,Y,player);
		return ally;
	}

	public static function addBullet(bullets:FlxTypedGroup<Bullet>, X:Int, Y:Int, GunType:Int, Type:Int){
		var bullet = bullets.recycle(Bullet);
		Sounds.play("shoot");
		var attack = 1; 
		switch (GunType) {
			case 0:
				// horizontal only
				bullet.init(X,Y+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Type,attack,0);
				bullet = bullets.recycle(Bullet);
				bullet.init(X,Y+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Type,attack,180);
			case 1:
				// vertical only
				bullet.init(X+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Y,Type,attack,90);
				bullet = bullets.recycle(Bullet);
				bullet.init(X+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Y,Type,attack,-90);
			case 2:
				// X only
				bullet.init(X+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Y+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Type,attack,45);
				bullet = bullets.recycle(Bullet);
				bullet.init(X+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Y+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Type,attack,-45);
				bullet = bullets.recycle(Bullet);
				bullet.init(X+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Y+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Type,attack,135);
				bullet = bullets.recycle(Bullet);
				bullet.init(X+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Y+Std.int(Std.random(Std.int(Util.TILE_SIZE/4))-Util.TILE_SIZE/8),Type,attack,-135);
		}
	}

	public static function createHomebase(X:Int, Y:Int, Health:Int):Homebase{
		var point = Util.toCameraCoordinates(X,Y);
		var homebase = new Homebase(Std.int(point.x), Std.int(point.y), Health);
		return homebase;
	}

	public static function addSpawnPoint(spawns:FlxTypedGroup<SpawnArea>,X:Int,Y:Int,enemies:FlxTypedGroup<Enemy>, 
											waves:Array<Array<Int>>):SpawnArea{
		var point = Util.toCameraCoordinates(X,Y);
		var spawnArea = spawns.recycle(SpawnArea);
		spawnArea.init(Std.int(point.x), Std.int(point.y),enemies,waves);
		return spawnArea;
	}

	public static function createPlayer(X:Int, Y:Int, allies:FlxTypedGroup<Ally>):Player{
		var point = Util.toCameraCoordinates(X,Y);
		return new Player(Std.int(point.x), Std.int(point.y),allies);       
	}

}