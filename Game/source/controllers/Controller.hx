package controllers;

import haxe.macro.Expr;
import gameObjects.GameObject;
import gameObjects.npcs.Worker;
import gameObjects.npcs.Enemy;
import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tile;
import gameObjects.mapObjects.Tower;
import flixel.FlxState;
import interfaces.Interactable;

/**
* @author: Chang Lu
*
* Controls all the array keeping for GameObjects and manages how each GameObjectController updates
*/
class Controller
{
	private var frameRate:Int;
	private var state:FlxState;

	private var workers:Array<Worker>;
	private var enemies:Array<Enemy>;
	private var terrains:Array<Tile>;
	private var projectiles:Array<Projectile>;
	private var towers:Array<Tower>;
	private var other:Array<GameObject>;

	private var projectileController:ProjectileController;
	private var enemyController:EnemyController;
	private var workerController:WorkerController;
	private var towerController:TowerController;

	public function new(state:FlxState,frameRate:Int=60): Void{
		this.frameRate = frameRate;
		this.state = state;

		this.workers = new Array<Worker>();
		this.enemies = new Array<Enemy>();
		this.terrains = new Array<Tile>();
		this.projectiles = new Array<Projectile>();
		this.towers = new Array<Tower>();
		this.other = new Array<GameObject>();

		projectileController = new ProjectileController(frameRate);
		enemyController = new EnemyController(frameRate);
		workerController = new WorkerController(frameRate);
		towerController = new TowerController(frameRate);
	}

	public function update(): Void{
		for(w in workers)
			workerController.update(w,cast([cast(terrains)]));
		for(e in enemies) 
			enemyController.update(e,cast([cast(terrains),cast(workers),cast(other)]));
		for(p in projectiles) 
			projectileController.update(p,cast([cast(terrains),cast(enemies),cast(workers)]));
		for(t in towers) 
			towerController.update(t,cast([cast(terrains),cast(enemies)]));
		

		// clean up arrays
		cleanUp(cast(workers));
		cleanUp(cast(enemies));
		cleanUp(cast(projectiles));
		cleanUp(cast(terrains));
		cleanUp(cast(towers));
		cleanUp(cast(other));
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
			default:
				addOther(obj); 
		}

		state.add(obj);
	}

	public function getInteractables():Array<Interactable>{
		var interactables: Array<Interactable> = []; 
		for (i in getAll()) {
			if (Std.is(i, Interactable)) {
				interactables.push(cast(i, Interactable));
			}
		}

		return interactables;
	}

	private function getAll():Array<GameObject>{
		return other.concat(cast(workers.concat(cast(enemies.concat(cast(projectiles.concat(cast(terrains.concat(cast(towers))))))))));
	}

	private function cleanUp(list:Array<GameObject>){
		for(i in list)
			if(!i.exists) list.remove(i);
	}

	private function addWorker(obj:Worker):Void{ 
		workers.push(obj); 
		workerController.addAnimation(obj);
	}

	private function addEnemy(obj:Enemy):Void{ 
		enemies.push(obj);
		enemyController.addAnimation(obj); 
	}

	private function addTerrain(obj:Tile):Void{ 
		terrains.push(obj); 
	}

	private function addTower(obj:Tower):Void{ 
		towers.push(obj); 
	}

	private function addProjectile(obj:Projectile):Void{ 
		projectiles.push(obj); 
	}

	private function addOther(obj:GameObject):Void{ 
		other.push(obj); 
	}
}
