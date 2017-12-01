package controllers;

import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxPath;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxButton;
import flixel.ui.FlxBar; 
import flixel.system.FlxSound;
import openfl.Assets;
using StringTools;

import gameStates.*;
import gameObjects.*;
import utils.*;

@:enum
abstract CollisionID(Int) {
	var None = 0;
	var EH = 1;
	var EB = 2;
	var AE = 3;
	var AT = 4;
	var AH =5;
	var PH =6;
	var PE = 7;
	var PT =8;
	var PS = 9;
}
class CollisionController{
	private var originalMap:FlxTilemap;
	private var towerMap:FlxTilemap;
	private var player:Player;
	private var enemies:FlxTypedGroup<Enemy>;
	private var allies:FlxTypedGroup<Ally>;
	private var bullets:FlxTypedGroup<Bullet>;
	private var towers:FlxTypedGroup<Tower>;
	private var homebase:Homebase;
	private var spawnArea:FlxTypedGroup<SpawnArea>;
	private var state:FlxState;

	private var prevCollision:CollisionID;
	private var collisionDetected:Bool;
	public function new(originalMap:FlxTilemap, towerMap:FlxTilemap, player:Player, allies:FlxTypedGroup<Ally>,
						enemies:FlxTypedGroup<Enemy>, bullets:FlxTypedGroup<Bullet>, towers:FlxTypedGroup<Tower>,
						homebase:Homebase, spawns:FlxTypedGroup<SpawnArea>, state:FlxState){
		this.originalMap = originalMap;
		this.towerMap = towerMap;
		this.player = player;
		this.allies = allies;
		this.enemies = enemies;
		this.bullets = bullets;
		this.towers = towers;
		this.homebase = homebase;
		this.spawnArea = spawns;
		this.state = state;

		prevCollision = CollisionID.None;
		collisionDetected = false;
	}

	public function update(elapsed:Float){
		collisionDetected = false;

		// bullet interaction
		FlxG.collide(originalMap,bullets,function(m,b) b.kill());

		// enemy interactions
		FlxG.overlap(enemies, homebase, hitEnemyHomebase);
		FlxG.overlap(enemies, bullets, hitEnemyBullet);
		FlxG.collide(towerMap, enemies);

		// ally interactions
		FlxG.overlap(allies, enemies, hitAllyEnemy);
		FlxG.overlap(allies, towers, hitAllyTower);
		FlxG.overlap(allies, homebase, hitAllyHomebase);
		FlxG.collide(originalMap, allies);

		// player interactions
		if (player!= null){
			FlxG.overlap(player, homebase, hitPlayerHomebase);
			FlxG.overlap(player, enemies, hitPlayerEnemy);
			FlxG.overlap(player, towers, hitPlayerTower);
			FlxG.overlap(player, spawnArea, hitPlayerSpawnArea);
			FlxG.overlap(player, allies, hitPlayerAlly);
			FlxG.collide(originalMap, player);
		}

		// mouse clicks tower region
		if (FlxG.mouse.justPressed){
			var selectedTower = getTowerAt(FlxG.mouse.x,FlxG.mouse.y);
			if (selectedTower != null)
				hitPlayerTower(player, selectedTower);
		}

		for(t in towers){
			if (t.alive && t.created){
				for (s in spawnArea)
					s.playerReady = true;
				break;
			}
		}

		if (!collisionDetected){
			prevCollision = CollisionID.None;
		}

		enemies.forEachAlive(hitEnemyTower);


	}
	private function getTowerAt(X:Int,Y:Int):Null<Tower>{
		for (t in towers){
			if (t.overlapsPoint(new FlxPoint(X,Y)))
				return t;
		}
		return null;
	}
	private function hitEnemyHomebase(e:Enemy, obj:FlxObject){
		if (e.alive){
			Sounds.play("life_loss");
			e._healthBar.kill();
			homebase.hurt(1);
			e.kill();
		}
	}
	private function hitEnemyBullet(e:Enemy, b:Bullet){
		if (e.alive && b.alive){
      		Sounds.play("enemy_hit");
			e.hurt(b.attackPt);
			b.kill();
		}
	}
	private function hitEnemyTower(e:Enemy) {
		if(e.isAttacking)
			return;

		var midpoint = e.getMidpoint();
		var nearest = getNearestTower(midpoint.x, midpoint.y, e.attackRange);

		// return if there are no towers within range
		if (nearest == null || !nearest.created)
			return;

		e.attack(nearest);
	}

	private function hitAllyEnemy(a:Ally,e:Enemy){
		if (e.alive && a.alive){
			e.kill();
			a.kill();
		}
	}
	private function hitAllyTower(a:Ally,t:Tower){
		if (a.alive && !a.inTower && a.target == null && t.created && t.alive){
			a.inTower = true;
			a.target = t;
			t.addWorker(a);
		}
	}
	private function hitAllyHomebase(a:Ally,obj:FlxObject){
		if (a.alive && a.target == null){
			homebase.health++;
			a.kill();
		}
	}
	private function hitPlayerHomebase(p:Player, obj:FlxObject){
		if(p.alive && homebase.health > 0 && prevCollision != CollisionID.PH){
			homebase.health--;
			var ally = GameObjectFactory.addAlly(allies,Std.int(homebase.midpoint.x),Std.int(homebase.midpoint.y),p);
			ally.inTower = false;
			ally.target = p;
		}

		prevCollision = CollisionID.PH;
		collisionDetected = true;
	}
	private function hitPlayerEnemy(p:Player, e:Enemy){
		if (p.alive && e.alive){
			p.kill();
		}
	}
	private function hitPlayerTower(p:Player, t:Tower){
		if (prevCollision != CollisionID.PT){
			// if the player hasn't made a tower here yet
			if (state.subState == null){
				Sounds.play("select");
				state.openSubState(new BuildState(t));
			}
		}
		else if(t.created && p!=null && prevCollision != CollisionID.PT){
			// if the player has already made a tower here but wants to retrieve the ally from it
			var ally = t.popWorker();
			if (ally != null){
				ally.inTower = false;
				ally.target = p;
			}
		}
		
		prevCollision = CollisionID.PT;
		collisionDetected = true;
	}
	private function hitPlayerSpawnArea(p:Player, obj:FlxObject){
		trace("hitPlayerSpawnArea");
	}
	private function hitPlayerAlly(p:Player, a:Ally){
		if (a.alive && a.velocity.x == 0 && a.velocity.y == 0)
			a.target = p;
	}

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