package controllers;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import gameObjects.*;
import ui.HUD;
import Constants;

class CollisionController{
	// Public groups
	public var bullets:FlxTypedGroup<Bullet>;
	public var emitters:FlxTypedGroup<EnemyExplosion>;
	public var enemies:FlxTypedGroup<Enemy>;
	public var towerIndicators:FlxTypedGroup<FlxSprite>;
	public var towers:FlxTypedGroup<Tower>;

	// Single game elements
	public var goal:FlxSprite;

	public function new(goalPosition:FlxPoint){
		// Add groups

		bullets = new FlxTypedGroup<Bullet>();
		emitters = new FlxTypedGroup<EnemyExplosion>();
		enemies = new FlxTypedGroup<Enemy>();
		towers = new FlxTypedGroup<Tower>();
		towerIndicators = new FlxTypedGroup<FlxSprite>();
		
		goal = new FlxSprite(goalPosition.x, goalPosition.y, AssetPaths.homebase__png);
	}

	public function update(e:Float):Void{
		// If an enemy hits the goal, it will lose life and the enemy explodes
		
		FlxG.overlap(enemies, goal, hitGoal);
		
		// If a bullet hits an enemy, it will lose health
		
		FlxG.overlap(bullets, enemies, hitEnemy);

		// If an enemy is within attacking range of a tower

		enemies.forEachAlive(hitTower);
	}

	public function addToState(state:FlxState):Void{
		state.add(bullets);
		state.add(emitters);
		state.add(enemies);
		state.add(towers);
		state.add(towerIndicators);
		state.add(goal);		
	}
	
	/**
	 * Called when trying to clean up after the game is done
	 */
	public function kill():Void{
		enemies.kill();
		towerIndicators.kill();
		towers.kill();
		bullets.kill();
		// emitters.kill();
	}
	
	/**
	 * Called when a bullet hits an enemy. Damages the enemy, kills the bullet.
	 */
	public function hitEnemy(bullet:Bullet, enemy:FlxSprite):Void
	{
		enemy.hurt(bullet.damage);
		bullet.kill();
		
		Constants.play("assets/sounds/enemy_hit.mp3");
	}

	/**
	 * Called when an enemy collides with a goal. Explodes the enemy, damages the goal.
	 */
	public function hitGoal(enemy:Enemy, goal:FlxSprite):Void
	{
		HUD.health--;
		enemy.explode(false);
		
		Constants.play("assets/sounds/hurt.mp3");
	}

	/**
	 * Called when an enemy is within attacking range with a tower. Enemy stops to attack tower
	 */
	public function hitTower(enemy:Enemy):Void
	{
		// return if its already attacking someone
		if(enemy.isAttacking)
			return;

		var midpoint = enemy.getMidpoint();
		var nearest = getNearestTower(midpoint.x, midpoint.y, enemy.attackRange);

		// return if there are no towers within range
		if (nearest == null)
			return;

		// pause its path if it has one
		if (enemy.path != null){
			enemy.pausePath();
		}

		enemy.attack(nearest);
	}
	
	/**
	 * Called when a point tries to select a tower. Returns null if the point doesn't overlap with a tower
	 */
	public function overlapsTower(x:Int, y:Int):Null<Tower>{
		for (tower in towers)
			if (tower.alive && FlxMath.pointInCoordinates(x, y, Std.int(tower.x), Std.int(tower.y), Std.int(tower.width), Std.int(tower.height)))
				return tower;
		return null;
	}


	/**
	 * Used to get the nearest tower within a particular search radius
	 * 
	 * @param	X				The X position of the screen touch.
	 * @param	Y				The Y position of the screen touch.
	 * @param	SearchRadius	How far from the touch point to search.
	 * @return	The nearest tower, as a Tower object.
	 */
	public function getNearestTower(X:Float, Y:Float, SearchRadius:Float):Tower
	{
		var minDistance:Float = SearchRadius;
		var closestTower:Tower = null;
		var searchPoint = FlxPoint.get(X, Y);
		
		for (tower in towers)
		{
			var dist:Float = searchPoint.distanceTo(tower.getMidpoint());
			
			if (dist < minDistance)
			{
				closestTower = tower;
				minDistance = dist;
			}
		}
		
		return closestTower;
	}
}