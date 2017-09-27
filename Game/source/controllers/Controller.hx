package controllers;

import haxe.macro.Expr;
import flixel.FlxG;
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
import gameObjects.mapObjects.HomeBase;
import gameObjects.mapObjects.BuildArea;
import gameObjects.materials.TowerBlock;
import gameObjects.materials.Ammunition;
using Lambda;

/**
* @author: Chang Lu
*
* Controls all the array keeping for GameObjects and manages how each GameObjectController updates
* TODO: refactor such that collisions happen between material and buildArea.
*/
class Controller
{
	private var frameRate:Int;
	private var state:FlxState;
	private var gameObjects:FlxTypedGroup<FlxObject>;

	private var homeBases:FlxTypedGroup<HomeBase>;
	private var buildAreas:FlxTypedGroup<BuildArea>;
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
		this.buildAreas = new FlxTypedGroup<BuildArea>(Constants.MAX_GAME_OBJECTS);
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
			case BuildArea:
				buildAreas.add(cast(obj, BuildArea));
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
		FlxG.overlap(towerController,other,function(t,o) {
			var inZone = FlxG.overlap(towerController, buildAreas) && FlxG.overlap(other, buildAreas);
			if (Std.is(o,TowerBlock) && inZone)
			 	towerController.collideTowerBlock(t,cast(o,TowerBlock));
			else if (Std.is(o,Ammunition) && inZone)
			 	towerController.collideAmmo(t,cast(o,Ammunition));
		});
		FlxG.overlap(other,other,collideMaterials);
	}

	private function collideMaterials(obj1:GameObject, obj2:GameObject){
		if(Std.is(obj1, TowerBlock) && Std.is(obj2, TowerBlock) && 
			!cast(obj1,TowerBlock).inTower && !cast(obj2,TowerBlock).inTower &&
			FlxG.overlap(obj1, buildAreas) && FlxG.overlap(obj2, buildAreas)){
			var matList = new List<TowerBlock>();
			matList.add(cast(obj1));
			matList.add(cast(obj2));
			add(GameObjectFactory.createTower(obj2.x, obj2.y, matList, 
				GameObjectFactory.createAmmunition(obj2.x, obj2.y)));
		}
	}

	private function collideBuildArea(obj1:GameObject, obj2:GameObject):Bool
	{
		if(FlxG.overlap(obj1, buildAreas) && FlxG.overlap(obj2, buildAreas)){
			return true;
		}
		else{
			return false;
		}
	}
}
