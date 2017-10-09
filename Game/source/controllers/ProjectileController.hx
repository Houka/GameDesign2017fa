package controllers;

import haxe.macro.Expr;
import haxe.ds.GenericStack;
import gameObjects.GameObject;
import gameObjects.mapObjects.Projectile;
import gameObjects.mapObjects.Tile;
import gameObjects.npcs.NPC;
import gameObjects.npcs.Worker;
import gameObjects.npcs.Enemy;
import flixel.FlxG;

class ProjectileController extends GameObjectController<Projectile>
{
	public function new(maxSize:Int=0, frameRate:Int=60):Void{
		super(maxSize,frameRate);
	}

	override private function updateState(obj:Projectile): Void{
		super.updateState(obj);
		switch (obj.state){
			case Moving: 
        		if(!obj.isOnScreen())
					obj.state = ProjectileState.Dying;
			case Dying:
				obj.destroy();
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

	/***********************************Collison Functions*****************************************/
	public function collideNPC(projectile:Projectile, npc:NPC):Void{
		if ((projectile.isEnemyProjectile && Type.getClass(npc) == Worker) ||
			(!projectile.isEnemyProjectile && Type.getClass(npc) == Enemy)){
			npc.takeDamage(projectile);
			projectile.state = ProjectileState.Dying;
		}
	}

	public function collideTerrain(projectile:Projectile, terrain:Tile):Void{
		if (terrain.type != TileType.Background)
			projectile.state = ProjectileState.Dying;
	}
}
