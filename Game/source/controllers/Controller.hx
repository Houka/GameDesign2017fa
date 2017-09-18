package controllers;

import gameObjects.*;
import haxe.macro.Expr;

class Controller
{
	private var frameRate:Int;
	private var workers:Array<Worker>;
	private var enemies:Array<Enemy>;
	private var terrains:Array<GameObject>;
	private var projectiles:Array<Projectile>;

	private var projectileController:ProjectileController;
	private var enemyController:EnemyController;
	private var workerController:WorkerController;

	public function new(frameRate:Int=60): Void{
		this.frameRate = frameRate;
		this.workers = new Array<Worker>();
		this.enemies = new Array<Enemy>();
		this.terrains = new Array<GameObject>();
		this.projectiles = new Array<Projectile>();
		projectileController = new ProjectileController();
		enemyController = new EnemyController();
		workerController = new WorkerController();
	}

	public function update(): Void{
		for(w in workers)
			workerController.update(w,cast([terrains]));
		for(e in enemies) 
			enemyController.update(e,cast([cast(terrains),cast(workers)]));
		for(p in projectiles) 
			projectileController.update(p,cast([cast(terrains),cast(enemies),cast(workers)]));
		

		// clean up arrays
		for(w in workers)
			if(!w.exists) workers.remove(w);
		for(e in enemies)
			if(!e.exists) enemies.remove(e);
		for(p in projectiles)
			if(!p.exists) projectiles.remove(p);

	}

	public function addWorker(obj:Worker):Void{ 
		workers.push(obj); 
		workerController.addAnimation(obj);
	}
	public function addEnemy(obj:Enemy):Void{ 
		enemies.push(obj);
		enemyController.addAnimation(obj); 
	}
	public function addTerrain(obj:GameObject):Void{ terrains.push(obj); }
	public function addProjectile(obj:Projectile):Void{ projectiles.push(obj); }
}
