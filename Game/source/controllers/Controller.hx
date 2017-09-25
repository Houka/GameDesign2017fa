package controllers;

import haxe.macro.Expr;
import haxe.ds.GenericStack;
import flixel.FlxG;
import flixel.FlxState;
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
	private var gameObjects:FlxTypedGroup<GameObject>;

	private var workers:GenericStack<Worker>;
	private var enemies:GenericStack<Enemy>;
	private var terrains:GenericStack<Tile>;
	private var projectiles:GenericStack<Projectile>;
	private var towers:GenericStack<Tower>;
	private var homeBases:GenericStack<HomeBase>;
	private var other:GenericStack<GameObject>;

	private var projectileController:ProjectileController;
	private var enemyController:EnemyController;
	private var workerController:WorkerController;
	private var towerController:TowerController;

	public function new(state:FlxState,frameRate:Int=60): Void{
		this.frameRate = frameRate;
		this.state = state;
		this.gameObjects = new FlxTypedGroup<GameObject>(Constants.MAX_GAME_OBJECTS);
		state.add(gameObjects);

		this.workers = new GenericStack<Worker>();
		this.enemies = new GenericStack<Enemy>();
		this.terrains = new GenericStack<Tile>();
		this.projectiles = new GenericStack<Projectile>();
		this.towers = new GenericStack<Tower>();
		this.homeBases = new GenericStack<HomeBase>();
		this.other = new GenericStack<GameObject>();

		projectileController = new ProjectileController(frameRate);
		enemyController = new EnemyController(frameRate);
		workerController = new WorkerController(frameRate);
		towerController = new TowerController(frameRate);
	}

	public function update(): Void{
		for(w in workers)
			workerController.update(w);
		for(e in enemies){
			enemyController.update(e);
			checkCollision(e, homeBases, enemyController.collideHomebase);
		}
		for(p in projectiles) {
			projectileController.update(p);
			checkCollision(p, enemies, projectileController.collideNPC);
			checkCollision(p, workers, projectileController.collideNPC);
			checkCollision(p, terrains, projectileController.collideTerrain);
		}
		for(t in towers) {
			towerController.update(t);
			for (e in enemies)
				if(towerController.canTargetEnemy(t,e))
					break;
		}
		

		// clean up GenericStacks
		cleanUp(cast(workers));
		cleanUp(cast(enemies));
		cleanUp(cast(projectiles));
		cleanUp(cast(terrains));
		cleanUp(cast(towers));
		cleanUp(cast(homeBases));
		cleanUp(cast(other));

		// sort by y axis
		gameObjects.sort(FlxSort.byY, FlxSort.ASCENDING);
	}

	public function add(obj:GameObject):Void{
		switch (Type.getClass(obj)){
			case Worker:
				addWorker(cast(obj, Worker));
			case Enemy:
				addEnemy(cast(obj, Enemy));
			case Projectile:
				addProjectile(cast(obj, Projectile));
			case Tile:
				addTerrain(cast(obj, Tile));
			case Tower:
				addTower(cast(obj, Tower));
			case HomeBase:
				addHomeBase(cast(obj, HomeBase));
			default:
				addOther(obj); 
		}

		gameObjects.add(obj);
	}

	private function cleanUp(list:GenericStack<GameObject>){
		for(i in list){
			if(!i.exists) {
				i.destroy();
				list.remove(i);
				state.remove(i);
				i = null;
			}
		}
	}

	private function checkCollision(obj:GameObject, l:GenericStack<Dynamic>, f:Dynamic -> Dynamic -> Void){
		for (i in l)
			FlxG.overlap(obj,i,f);
	}

	private function addWorker(obj:Worker):Void{ 
		workers.add(obj); 
		workerController.addAnimation(obj);
	}
	private function addEnemy(obj:Enemy):Void{ 
		enemies.add(obj);
		enemyController.addAnimation(obj);
	}
	private function addHomeBase(obj:HomeBase):Void{ homeBases.add(obj); }	
	private function addTerrain(obj:Tile):Void{ terrains.add(obj); }
	private function addTower(obj:Tower):Void{ towers.add(obj); }
	private function addProjectile(obj:Projectile):Void{ projectiles.add(obj);}
	private function addOther(obj:GameObject):Void{ other.add(obj); }
}
