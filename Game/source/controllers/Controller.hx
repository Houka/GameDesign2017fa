package controllers;

import haxe.macro.Expr;
import flixel.FlxG;
import flixel.FlxBasic; 
import flixel.FlxState;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.util.FlxSort;
import gameObjects.GameObject;
import gameObjects.GameObjectFactory;
import gameObjects.npcs.Worker;
import gameObjects.npcs.Enemy;
import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tile;
import gameObjects.mapObjects.Tower;
import gameObjects.mapObjects.SpawnPoint; 
import gameObjects.mapObjects.HomeBase;
import gameObjects.materials.TowerBlock;
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
	}

	public function update(elapsed: Float): Void{
		projectileController.update(elapsed);
		enemyController.update(elapsed);
		workerController.update(elapsed);
		towerController.update(elapsed);
		towerController.forEachAlive( function(t) {
			enemyController.forEachAlive( function(e) towerController.canTargetEnemy(t,e) );
		});

		collide();

		gameObjects.sort(byY, FlxSort.ASCENDING); 
	}

	public function add(obj:GameObject):Void{
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
			case HomeBase:
				homeBases.add(cast(obj, HomeBase));
			default:
				other.add(obj); 
		}

		gameObjects.add(obj);

	}

	/**
	* Main collision function
	*/
	private function collide():Void{
		FlxG.overlap(enemyController,homeBases,enemyController.collideHomebase);
		FlxG.overlap(projectileController,enemyController,projectileController.collideNPC);
		FlxG.overlap(projectileController,workerController,projectileController.collideNPC);
		FlxG.overlap(projectileController,terrains,projectileController.collideTerrain);
		FlxG.overlap(towerController,other,function(t,o) {
			if (Std.is(o,TowerBlock))
			 	towerController.collideTowerBlock(t,cast(o,TowerBlock));
			else if (Std.is(o,Ammunition))
			 	towerController.collideAmmo(t,cast(o,Ammunition));
		});
		FlxG.overlap(other,other,collideMaterials);
	}

	private function collideMaterials(obj1:GameObject, obj2:GameObject){
		if(Std.is(obj1, TowerBlock) && Std.is(obj2, TowerBlock) && 
			!cast(obj1,TowerBlock).inTower && !cast(obj2,TowerBlock).inTower){
			var matList = new List<TowerBlock>();
			matList.add(cast(obj1));
			matList.add(cast(obj2));
			add(GameObjectFactory.createTower(obj2.x, obj2.y, matList, 
				GameObjectFactory.createAmmunition(obj2.x, obj2.y)));
		}
	}

	private function byY(Order:Int, Obj1:FlxObject, Obj2:FlxObject):Int
	{
		switch (Type.getClass(Obj1)){
			case Tile: 
				if (Type.getClass(Obj2) == Tile) {
					return FlxSort.byValues(Order, cast(Obj1, FlxObject).y, cast(Obj2, FlxObject).y);
				}
				return Order; 
			case Enemy: 
				if (Std.is(Obj2, Tile)) { 
					return -Order; 
				}
				if (Std.is(Obj2, Enemy)) {
					return FlxSort.byValues(Order, cast(Obj1, FlxObject).y, cast(Obj2, FlxObject).y);
				}
				return Order; 
			case Worker: 
				if (Std.is(Obj2, Tile)) { 
					return -Order; 
				}
				if (Std.is(Obj2, Enemy)) {
					return FlxSort.byValues(Order, cast(Obj1, FlxObject).y, cast(Obj2, FlxObject).y);
				}
				return Order; 
			case Tower: 
				return -Order; 
			case SpawnPoint:
				return Order; 
			case HomeBase: 
				return -Order;
			default: 
				return -Order; 
		}
	}
}
