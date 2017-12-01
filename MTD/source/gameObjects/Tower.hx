package gameObjects;

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

import utils.*;
import gameStates.*;

class Tower extends FlxSprite{
	public var created:Bool;
	public var map:FlxTilemap;
	
	private var towerLayers:FlxTypedGroup<FlxSprite>;
	private var bullets:FlxTypedGroup<Bullet>;
	private var children:Array<FlxSprite>;
	private var ammoType:Int;
	private var gunTypes:Array<Int>;
	private var foundationTypes: Array<Int>; 
	private var counter:Int;
	private var interval:Int = 2;
	private var workers:Array<Ally>;
	private var _healthBar: FlxBar; 
	private var dropshadow:FlxSprite;
	public function init(X:Int, Y:Int, bullets:FlxTypedGroup<Bullet>, towerLayers:FlxTypedGroup<FlxSprite>,map:FlxTilemap){
		loadGraphic(AssetPaths.towerPlaceholder__png);
		setPosition(X-Math.abs(width-Util.TILE_SIZE)/2,Y-Math.abs(height-Util.TILE_SIZE)/2);

		this.towerLayers = towerLayers;
		this.bullets = bullets;
		this.map = map;
		this.children = new Array<FlxSprite>();
		this.workers = new Array<Ally>();
		this.gunTypes = new Array<Int>();
		this.foundationTypes = new Array<Int>(); 
		counter = 0;
		health = 1; 
		created = false;
	}
	public function buildTower(materials:Array<Int>){
		var yOffset = 0;
		var midpoint = getMidpoint();
		for (m in materials){
			if (m < 6){
				// materials
				var layer = new FlxSprite();
				switch (m) {
					// gunbases
					case 0:
						layer.loadGraphic(AssetPaths.snowman_h__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						gunTypes.push(m);
						yOffset -= 30;
					case 1:
						layer.loadGraphic(AssetPaths.snowman_v__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset-3);
						towerLayers.add(layer);
						gunTypes.push(m);
						yOffset -= 30;

					case 2:
						layer.loadGraphic(AssetPaths.snowman_x__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						gunTypes.push(m);
						yOffset -= 30;

					// foundations
					case 3:
						layer.loadGraphic(AssetPaths.rusty__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 1; 
						yOffset -= 30;

					case 4:
						layer.loadGraphic(AssetPaths.plated__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 3; 
						yOffset -= 30;

					case 5:
						layer.loadGraphic(AssetPaths.steel__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 7; 
						yOffset -= 30;
				}

				children.push(layer);
			}
			else{
				// ammo. only one ammo expected in each materials list
				ammoType = m;
			}
		}

		created = children.length > 0;
		if (created){
			_healthBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 30, 4, this, "health", 0, this.health, true);
			_healthBar.trackParent(15, 55);
			_healthBar.visible = created; 
			FlxG.state.add(_healthBar);
			map.setTile(Std.int(getMidpoint().x / Constants.TILE_SIZE), Std.int(getMidpoint().y / Constants.TILE_SIZE), 1, false);

			// add animation for towers
			for (i in 0...children.length){
				var c = children[i];
				var tween = FlxTween.tween(c, { y: c.y }, 0.5, { ease: FlxEase.expoOut, startDelay:i*0.1});
				c.y -= FlxG.height;
			}
		}

		//add dropshadow
		dropshadow = new FlxSprite();
		dropshadow.loadGraphic(AssetPaths.tower__png);
		dropshadow.setPosition(midpoint.x-dropshadow.width/2, midpoint.y+8);
		FlxG.state.add(dropshadow);
	}
	public function addWorker(a:Ally){
		workers.push(a);
	}
	public function popWorker():Ally{
		return workers.pop();
	}
	override public function update(elapsed:Float){
		super.update(elapsed);

		// TODO: if an enemy is within range then shoot by creating bullet depending on ammo type
		if (children.length > 0 && gunTypes.length > 0 && workers.length > 0){
			counter += Std.int(FlxG.timeScale);
			if (counter > interval * FlxG.updateFramerate){
				for (g in gunTypes)
					GameObjectFactory.addBullet(bullets, Std.int(getMidpoint().x), Std.int(getMidpoint().y), g, ammoType);
				counter = 0;
			}
		}
	}

	override public function hurt(Damage:Float):Void {
		health -= Damage;

		// flash each child as red with a delay
		for (i in 0...children.length){
			Util.animateDamage(children[i],i);
		}
		
		if (health <= 0){
			Sounds.play("destroyed");

			created = false; 
			_healthBar.visible = false;
			_healthBar.kill();
			dropshadow.kill();
			for (c in children)
				c.kill();
			var savedWorkers = workers;
			init(Std.int(x), Std.int(y), bullets, towerLayers, map);
			workers = savedWorkers;
			map.setTile(Std.int(getMidpoint().x / Constants.TILE_SIZE), Std.int(getMidpoint().y / Constants.TILE_SIZE), 0, false);

			//for logging
			GameState.towersKilled++;

			if (GameState.tutorialEvent == 3) { 
				FlxG.state.add(GameState.tutorialArrow);
				GameState.tutorialArrow.visible = true; 
				GameState.tutorialArrow.setPosition(x-40, y);  
				GameState.tutorialEvent++; 
			}
		}
	}
}