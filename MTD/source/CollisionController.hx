package;

import flixel.group.FlxGroup;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import Constants;

class CollisionController{
	// Public groups
	public var bullets:FlxTypedGroup<Bullet>;
	public var emitters:FlxTypedGroup<EnemyGibs>;
	public var enemies:FlxTypedGroup<Enemy>;
	public var towerIndicators:FlxTypedGroup<FlxSprite>;
	public var towers:FlxTypedGroup<Tower>;

	// Single game elements
	public var goal:FlxSprite;

	public function new(goalPosition:FlxPoint){
		// Add groups

		bullets = new FlxTypedGroup<Bullet>();
		emitters = new FlxTypedGroup<EnemyGibs>();
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
	 * Called when a point tries to select a tower. Returns null if the point doesn't overlap with a tower
	 */
	public function overlapsTower(x:Int, y:Int):Null<Tower>{
		for (tower in towers)
			if (tower.alive && FlxMath.pointInCoordinates(x, y, Std.int(tower.x), Std.int(tower.y), Std.int(tower.width), Std.int(tower.height)))
				return tower;
		return null;
	}
}