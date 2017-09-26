package controllers;

import haxe.macro.Expr;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import gameObjects.GameObject;
import gameObjects.npcs.Worker;
import gameObjects.npcs.Enemy;
import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tile;
import gameObjects.mapObjects.Tower;
import gameObjects.mapObjects.HomeBase;
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

	private var homeBases:FlxTypedGroup<HomeBase>;
	private var terrains:FlxTypedGroup<Tile>;
	private var other:FlxTypedGroup<GameObject>;

	private var projectileController:ProjectileController;
	private var enemyController:EnemyController;
	private var workerController:WorkerController;
	private var towerController:TowerController;

	public function new(state:FlxState,frameRate:Int=60): Void{
		this.frameRate = frameRate;
		this.state = state;
		this.gameObjects = new FlxTypedGroup<FlxObject>(Constants.MAX_GAME_OBJECTS);

		this.terrains = new FlxTypedGroup<Tile>(Constants.MAX_GAME_OBJECTS);
		this.homeBases = new FlxTypedGroup<HomeBase>(Constants.MAX_GAME_OBJECTS);
		this.other = new FlxTypedGroup<GameObject>(Constants.MAX_GAME_OBJECTS);

		projectileController = new ProjectileController(Constants.MAX_GAME_OBJECTS,frameRate);
		enemyController = new EnemyController(Constants.MAX_GAME_OBJECTS,frameRate);
		workerController = new WorkerController(Constants.MAX_GAME_OBJECTS,frameRate);
		towerController = new TowerController(Constants.MAX_GAME_OBJECTS,frameRate);

		state.add(gameObjects);
		state.add(projectileController);
		state.add(enemyController);
		state.add(workerController);
		state.add(towerController);
	}

	public function update(): Void{
		towerController.forEachAlive( function(t) {
			enemyController.forEachAlive( function(e) towerController.canTargetEnemy(t,e) );
		});

		collide();
	}

	public function add(obj:GameObject):Void{
		var canAdd = false;
		switch (Type.getClass(obj)){
			case Worker:
				workerController.add(cast(obj, Worker));
			case Enemy:
				enemyController.add(cast(obj, Enemy));
			case Projectile:
				projectileController.add(cast(obj, Projectile));
			case Tower:
				towerController.add(cast(obj, Tower));
			case Tile:
				terrains.add(cast(obj, Tile));
				canAdd = true;
			case HomeBase:
				homeBases.add(cast(obj, HomeBase));
				canAdd = true;
			default:
				other.add(obj); 
				canAdd = true;
		}

		if (canAdd){
			gameObjects.add(obj);
			gameObjects.sort(FlxSort.byY, FlxSort.ASCENDING);
		}
	}

	/**
	* Main collision function
	*/
	private function collide():Void{
		FlxG.overlap(enemyController,homeBases,enemyController.collideHomebase);
		FlxG.overlap(projectileController,enemyController,projectileController.collideNPC);
		FlxG.overlap(projectileController,workerController,projectileController.collideNPC);
		FlxG.overlap(projectileController,terrains,projectileController.collideTerrain);
	}
}
