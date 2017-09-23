package controllers;

import haxe.macro.Expr;
import gameObjects.GameObject;
import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tile;
import gameObjects.npcs.Worker;
import gameObjects.npcs.Enemy;
import flixel.FlxG;

class ProjectileController extends GameObjectController<Projectile>
{
	public function new(frameRate:Int=60):Void{
		super(frameRate);
	}

	/**
	*  extraArguments = <list of terrain objs>, ?<list of enemies>, ?<list of workers>
	*/
	override private function updateState(obj:Projectile,?extraArguments:Array<Expr>): Void{
		super.updateState(obj,extraArguments);
		// makes sure there are extra arguments being passed in
		if (extraArguments == null){
		 	trace("Error: Projectile needs <list of terrain objs>, ?<list of enemies> ?<list of workers> 
		 			for its update... using naive update for Projectile");
		 	nativeUpdateState(obj);
		}
		else{
			smartUpdateState(obj,cast(extraArguments[0]), cast(extraArguments[1]), cast(extraArguments[2]));
		}
	}

	override private function updateAnimation(obj:Projectile): Void{
		super.updateAnimation(obj);
		// Nothing to implement unless we want an animation for when a projectile hits a target or if there's animation as it movies
	}

	override public function addAnimation(obj:Projectile): Void{
		super.addAnimation(obj);
		// Nothing to implement unless we want an animation for when a projectile hits a target or if there's animation as it movies
	}

	/** very naive and simple implementation with no collision detection */
	private function nativeUpdateState(obj:Projectile):Void{
		switch (obj.state){
			case Moving: 
        		if(!obj.isOnScreen())
					obj.state = ProjectileState.Dying;
			case Dying:
				obj.kill();
		}
	}


	/** smarter implementation of state switching with collision detechtion */
	private function smartUpdateState(obj:Projectile,terrains:Array<Tile>,
										?enemies:Array<Enemy>, ?workers:Array<Worker>):Void{
		switch (obj.state){
			case Moving: 
        		if(!obj.isOnScreen())
					obj.state = ProjectileState.Dying;

				if (obj.isEnemyProjectile){
					for(w in workers){
						if (FlxG.collide(obj,w)){
							w.takeDamage(obj);
							obj.state = ProjectileState.Dying;
						}
					}
				}else{
					for(e in enemies){
						if (FlxG.collide(obj,e)){
							e.takeDamage(obj);
							obj.state = ProjectileState.Dying;
						}
					}
				}

				for(t in terrains){
					if (t.type != TileType.Background && FlxG.collide(obj,t))
						obj.state = ProjectileState.Dying;
				}

			case Dying:
				obj.kill();
		}
	}
}
