package controllers;

import haxe.macro.Expr;
import flixel.FlxG;
import flixel.FlxBasic; 
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import flixel.math.FlxPoint;
import gameObjects.GameObject;
import gameObjects.GameObjectFactory;
import gameObjects.npcs.Worker;
import gameObjects.npcs.Enemy;
import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tile;
import gameObjects.mapObjects.Tower;
import gameObjects.mapObjects.Coin;
import gameObjects.mapObjects.SpawnPoint; 
import gameObjects.mapObjects.HomeBase;
import gameObjects.mapObjects.BuildArea;
import gameObjects.materials.TowerBlock;
import gameObjects.materials.Material;
import gameObjects.materials.Ammunition;
using Lambda;

/**
* @author: Chang Lu
*
* Controls all the array keeping for GameObjects and manages how each GameObjectController updates
*/
class Controller
{
	private var frameRate:Int;
	private var state:FlxState;
	private var gameObjects:FlxTypedGroup<FlxObject>;

	private var homeBase:HomeBase;
	private var buildArea:BuildArea;
	private var terrains:FlxTypedGroup<Tile>;
	private var other:FlxTypedGroup<GameObject>;
	private var spawnPoints:FlxTypedGroup<SpawnPoint>;

	private var projectileController:ProjectileController;
	private var enemyController:EnemyController;
	private var workerController:WorkerController;
	private var towerController:TowerController;

	private var path:Array<FlxPoint>;

	public function new(state:FlxState,path:Array<FlxPoint>,frameRate:Int=60): Void{
		this.path = path;
		this.frameRate = frameRate;
		this.state = state;
		this.gameObjects = new FlxTypedGroup<FlxObject>(Constants.MAX_GAME_OBJECTS);

		this.terrains = new FlxTypedGroup<Tile>(Constants.MAX_GAME_OBJECTS);
		this.other = new FlxTypedGroup<GameObject>(Constants.MAX_GAME_OBJECTS);
		this.spawnPoints = new FlxTypedGroup<SpawnPoint>(Constants.MAX_GAME_OBJECTS);
		this.buildArea = GameObjectFactory.createBuildArea(FlxG.width*3/4, 0);
		this.homeBase = null;

		projectileController = new ProjectileController(Constants.MAX_GAME_OBJECTS,frameRate);
		enemyController = new EnemyController(Constants.MAX_GAME_OBJECTS,frameRate);
		workerController = new WorkerController(Constants.MAX_GAME_OBJECTS,frameRate);
		towerController = new TowerController(Constants.MAX_GAME_OBJECTS,frameRate);

		state.add(gameObjects);
		state.add(buildArea);
	}

	public function update(elapsed: Float): Void{
		projectileController.update(elapsed);
		enemyController.update(elapsed);
		workerController.update(elapsed);
		towerController.update(elapsed);

		collide();

		gameObjects.sort(byY, FlxSort.ASCENDING); 
	}

	public function add(obj:GameObject):Void{
		switch (Type.getClass(obj)){
			case Worker:
				workerController.add(cast(obj, Worker));
			case Enemy:
				enemyController.add(cast(obj, Enemy));
				cast(obj,Enemy).walkPath = path.copy();
			case Projectile:
				projectileController.add(cast(obj, Projectile));
			case Tower:
				towerController.add(cast(obj, Tower));
			case Tile:
				terrains.add(cast(obj, Tile));
			case HomeBase:
				homeBase = cast(obj, HomeBase);
				// homeBase.add(cast(obj, HomeBase));
			case BuildArea:
				buildArea.add(cast(obj, BuildArea));
			case SpawnPoint:
				spawnPoints.add(cast(obj, SpawnPoint));
				// homeBase = cast(obj, HomeBase);
			default:
				other.add(obj); //TODO: exclude Materials
		}

		gameObjects.add(obj);
	}
	
	// TODO: Return true after all waves are finished
	public function allEnemiesDead():Bool {
		var allDead: Bool = false;
		var moreWaves: Bool = true;
		spawnPoints.forEachExists( function(s) if (s.finished) { moreWaves = false; } else { moreWaves = true; } );
		if (enemyController.countLiving() == 0) {
			allDead = true;
		}
		return (allDead && !moreWaves);
	}

	/**
	* Main collision function
	*/
	private function collide():Void{
		FlxG.overlap(enemyController,homeBase,enemyController.collideHomebase);
		FlxG.overlap(projectileController,enemyController,projectileController.collideNPC);
		FlxG.overlap(projectileController,workerController,projectileController.collideNPC);
	}

	private function byY(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		return FlxSort.byValues(Order,Obj2.y*getLayerByObject(Obj2),Obj1.y*getLayerByObject(Obj1));
	}

	private function getLayerByObject(obj:FlxObject):Int{
		if (Std.is(obj,Coin))
			return 0;
		if (Std.is(obj,Projectile))
			return 0;
		if (Std.is(obj,Enemy))
			return 2;
		if (Std.is(obj,TowerBlock))
			return 2;
		if (Std.is(obj,Tile))
			return 4;
		
		return 3;
	}
}
