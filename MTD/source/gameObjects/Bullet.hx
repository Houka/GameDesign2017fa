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

import Logging;

class Bullet extends FlxSprite{
	public var attackPt:Int;
	public var type:Int;
	private var speed:Int;
	public function init(X:Int,Y:Int,Type:Int,Attack:Int,Angle:Int){
		switch (Type) {
			case 6:
				loadGraphic(AssetPaths.snowball__png,true,20,20);
				animation.add("idle",[0],10,true);
				animation.add("explode",[1,2,3,4,5],10,false);
				animation.play("idle");
			case 7:
				loadGraphic(AssetPaths.snowball2__png);
			case 8:
				loadGraphic(AssetPaths.snowball3__png);
		}

		setPosition(X-width/2,Y-height/2);
		speed = 200;
		type = Type;
		attackPt = Attack;
		angle = Angle;
		velocity.set(speed, 0);
		velocity.rotate(FlxPoint.weak(0,0), angle);
		alpha = 1;
	}

	override public function kill(){
		velocity.set(0,0);
		alive = false;
		animation.play("explode");
	}
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// get rid of off screen bullet or a too transparent bullet
		if (!isOnScreen(FlxG.camera) || alpha <= 0.8) 
		{
			kill();
		}
		
		alpha -= 0.005;

		if(!alive && animation.name=="explode" && animation.frameIndex == 4){
			super.kill();
		}
	}
}
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
		var yFoundOffset = 0; 
		var midpoint = getMidpoint();
		for (m in materials){
			if (m < 6){
				// materials
				var layer = new FlxSprite();
				switch (m) {
					// gunbases
					case 0:
						layer.loadGraphic(AssetPaths.snowman_head__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset - 10);
						layer.y += 10; 
						towerLayers.add(layer);
						gunTypes.push(m);
						yOffset -= 32;
					case 1:
						layer.loadGraphic(AssetPaths.snowman_machine_gun__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset - 4);
						towerLayers.add(layer);
						gunTypes.push(m);
						yOffset -= 32;

					case 2:
						layer.loadGraphic(AssetPaths.snowman_spray__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset + 10);
						yOffset += 14; 
						towerLayers.add(layer);
						gunTypes.push(m);
						yOffset -= 32;

					// foundations
					case 3:
						layer.loadGraphic(AssetPaths.snow1__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 1; 
						yOffset -= 25;

					case 4:
						layer.loadGraphic(AssetPaths.snowman_ice__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 2; 
						yOffset -= 25;

					case 5:
						layer.loadGraphic(AssetPaths.snowman_coal__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 3; 
						yOffset -= 25;
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
		}
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
		
		if (health <= 0){
			Sounds.play("destroyed");

			created = false; 
			_healthBar.visible = false;
			_healthBar.kill();
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