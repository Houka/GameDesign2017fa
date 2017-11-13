package test;

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
import openfl.Assets;
using StringTools;

import test.LevelSelectState;
import Logging;
import gameStates.MenuState;

////////////////////////// Level
////////////////////////////////
typedef Level = {
	var mapFilepath:String;
	var tilemap:String;
	var startHealth:Int;
	var waves:Array<Array<Int>>;
	var buttonTypes:Array<Int>;
	var buildLimit:Int;
}

class LevelData{
	public static var level1:Level = {
		mapFilepath:"assets/maps/level1.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0,0,0],
				[0,0,0,0,1]],
		buttonTypes:[0],
		buildLimit:1
	}
	
	public static var level2:Level = {
		mapFilepath:"assets/maps/level2.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:3,
		waves:[[0,0,0],
				[0,0,0],
				[0, 0,0,1]],
		buttonTypes:[0,3],
		buildLimit:1
	}
	
	public static var level3:Level = {
		mapFilepath:"assets/maps/level3.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1],
				[1, 1],
				[0, 1, 0, 1, 0],
				[1,1,0,0]],
		buttonTypes:[0, 1,3],
		buildLimit:2
	}
	
	public static var level4:Level = {
		mapFilepath:"assets/maps/level4.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1,1,1,1,1],
				[0, 1, 1, 0],
				[1, 1, 1, 1, 0,0,0,0],
				[0,0,0,1,1,1,0,0]],
		buttonTypes:[0, 1, 3],
		buildLimit:2
	}
	
	public static var level5:Level = {
		mapFilepath:"assets/maps/level5.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1],
				[0, 1, 2, 1, 0],
				[1, 1, 1, 1, 2, 2, 2],
				[2,2,0,0,1,2]],
		buttonTypes:[0, 1,2, 3],
		buildLimit:2
	}
	
	public static var level6:Level = {
		mapFilepath:"assets/maps/level6.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0],
				[0, 0, 0,0,0],
				[0, 1, 0, 1, 0],
				[0, 0, 0, 1, 1,1],
				[1, 1, 1, 1, 1, 1, 2, 2],
				[2, 2, 1, 2, 1, 1, 2],
				[2,2,2,2,2,2,2]],
		buttonTypes:[0, 1,2, 3,4],
		buildLimit:2
	}
	
	public static var level7:Level = {
		mapFilepath:"assets/maps/level7.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1,1,1],
				[1, 1, 1,2,2],
				[0, 1, 0,2,2,2],
				[1, 1,1,1,2,2]],
		buttonTypes:[0, 1,2, 3,4,5],
		buildLimit:2
	}
	
	public static var level8:Level = {
		mapFilepath:"assets/maps/level8.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1],
				[0, 1,2, 0]],
		buttonTypes:[0, 1,2, 3,4],
		buildLimit:3
	}
	
	public static var level9:Level = {
		mapFilepath:"assets/maps/level9.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1],
				[0, 1, 0],
				[1, 1, 1]],
		buttonTypes:[0, 1,2, 3,4],
		buildLimit:3
	}
	
	public static var level10:Level = {
		mapFilepath:"assets/maps/level10.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1],
				[1, 1, 1],
				[0, 1, 0],
				[1, 1]],
		buttonTypes:[0, 1,2, 3,4],
		buildLimit:3
	}
	
	public static var level11:Level = {
		mapFilepath:"assets/maps/level11.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0, 0, 0, 1, 1,1,1],
				[1, 1, 1,2,2],
				[0, 1, 0,2,2,2],
				[1, 1,1,1]],
		buttonTypes:[0, 1,2, 3,4,5],
		buildLimit:3
	}
	
	public static var level12:Level = {
		mapFilepath:"assets/maps/level12.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0],
				[1],
				[0,1],
				[1,1],
				[0, 0, 1, 1],
				[1],
				[0, 0],
				[2],
				[1, 0, 2],
				[2, 2],
				[1, 1, 2],
				[1, 2, 1, 2, 1],
				[2,2,2,2,0,0]],
		buttonTypes:[0, 1,2, 3,4,5],
		buildLimit:3
	}
	
	public static var level13:Level = {
		mapFilepath:"assets/maps/level13.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0],
				[1],
				[0,1],
				[1,1],
				[0, 0, 1, 1],
				[1],
				[0, 0,0],
				[2],
				[1, 0, 2],
				[2, 2,1],
				[1, 1, 2],
				[1, 2, 1, 2, 1],
				[2,2,2,2,0,0]],
		buttonTypes:[0, 1,2, 3,4,5],
		buildLimit:3
	}

	public static var levels = [level1, level2, level3, level4, level5, level6, level7, level8, level9, level10, level11, level12, level13];
	public static var currentLevel = 0;
	public static var maxLevelReached = currentLevel;
	public static function getCurrentLevel():Null<Level>{
		if (currentLevel>=levels.length){
			trace("Error: Level "+currentLevel+" does not exists");
			currentLevel = 0;
			return null;
		}
		
		return levels[currentLevel];
	}
	public static function gotoNextLevel():Null<Level>{
		currentLevel ++;
		maxLevelReached = Std.int(Math.max(currentLevel, maxLevelReached));
		if(maxLevelReached == 1){
			maxLevelReached = 2;
		}
		return getCurrentLevel();
	}
}

////////////////////////// Util
/////////////////////////////////

class Util{
	public static inline var TILE_SIZE:Int = 64;
	public static function loadCSV(MapData:String):Array<Array<Int>>{
		var _data:Array<Array<Int>>;

		// path to map data file?
		if (Assets.exists(MapData))
		{
			MapData = Assets.getText(MapData);
		}
		
		// Figure out the map dimensions based on the data string
		_data = new Array<Array<Int>>();
		var columns:Array<String>;
		
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
		var lines:Array<String> = regex.split(MapData);
		var rows:Array<String> = lines.filter(function(line) return line != "");
		
		for (rowString in rows)
		{
			var row:Array<Int> = new Array<Int>();
			if (rowString.endsWith(","))
				rowString = rowString.substr(0, rowString.length - 1);
			columns = rowString.split(",");

			for (columnString in columns)
			{
				//the current tile to be added:
				var curTile = Std.parseInt(columnString);
				
				if (curTile == null)
					throw 'String is not a valid integer: "$columnString"';
				
				row.push(curTile);
			}

			_data.push(row);
		}

		return _data;
	}

	public static function toMapCoordinates(x:Float, y:Float):FlxPoint{
		return FlxPoint.get(Std.int(x/TILE_SIZE), Std.int(y/TILE_SIZE));
	}
	
	/*  Returns the screen coordinates with respect to the camera
	*   x = the column position in map coordinates
	*   y = the row position in map coordinates
	*   where the first column and row is index 0
	*/
	public static function toCameraCoordinates(x:Int, y:Int):FlxPoint{
		return FlxPoint.get(x*TILE_SIZE, y*TILE_SIZE);
	}

	public static function copy2DArray(array:Array<Array<Int>>):Array<Array<Int>>{
		var copy = new Array<Array<Int>>();
		for (i in array){
			copy.push(i.copy());
		}
		return copy;
	}

	public static function copyPathFrom(Path:Array<FlxPoint>,Index:Int):Array<FlxPoint>{
		var result:Array<FlxPoint> = new Array<FlxPoint>();
		var tempPoint:FlxPoint;
		for (i in Index...Path.length){
			tempPoint = new FlxPoint(Path[i].x,Path[i].y);
			result.push(tempPoint);
		}

		return result;
	 }
}

class GameObjectFactory{
	public static var dummyAlly = new Ally();
	public static function addEnemy(enemies:FlxTypedGroup<Enemy>, X:Int, Y:Int, Type:Int, Path:Array<FlxPoint>):Enemy{
		var enemy = enemies.recycle(Enemy);	// uses an already added enemy, or makes a new one and adds it to enemies
		var _framerate:Int = 8;
		// make enemy based on type
		switch (Type) {	
			case 0:
				enemy.init(X,Y,Type,1,1,100);
				enemy.loadGraphic(AssetPaths.snow3_spritesheet__png, true, 64, 64);
				enemy.animation.add("idle",[0],_framerate, true);
				enemy.animation.add("walk_down",[0],_framerate, true);
				enemy.animation.add("walk_left",[0],_framerate, true);
				enemy.animation.add("walk_right",[0],_framerate, true);
				enemy.animation.add("walk_up",[0],_framerate, true);
				enemy.animation.add("attack",[0], 5, true);
				enemy.animation.play("idle");
			case 1:
				enemy.init(X,Y,Type,1,2,150);
				enemy.loadGraphic(AssetPaths.kid_spritesheet__png, true, 64, 64);
				enemy.animation.add("idle",[8],_framerate, true);
				enemy.animation.add("walk_down",[8,9,10,11,12,13,14,15],_framerate, true);
				enemy.animation.add("walk_left",[16,17,18,19,20,21,22,23],_framerate, true);
				enemy.animation.add("walk_right",[24,25,26,27,28,29,30,31],_framerate, true);
				enemy.animation.add("walk_up",[0,1,2,3,4,5,6,7],_framerate, true);
				enemy.animation.add("attack",[32,33,34,35,36,37], 5, true);
				enemy.animation.play("walk_down");
			case 2:
				enemy.init(X,Y,Type,2,5,100);
				enemy.loadGraphic(AssetPaths.enemy2_spritesheet_64x64__png, true, 64, 64);
				enemy.animation.add("idle",[0],_framerate, true);
				enemy.animation.add("walk_down",[0],_framerate, true);
				enemy.animation.add("walk_left",[0],_framerate, true);
				enemy.animation.add("walk_right",[0],_framerate, true);
				enemy.animation.add("walk_up",[0],_framerate, true);
				enemy.animation.add("attack",[0], 5, true);
				enemy.animation.play("idle");
			default:
				trace('No such enemy type: $Type');
		}

		// set a path for the enemies to follow
		enemy.followPath(Path);

		return enemy;
	}

	public static function addTower(towers:FlxTypedGroup<Tower>, X, Y, bullets:FlxTypedGroup<Bullet>, 
									towerLayers:FlxTypedGroup<FlxSprite>, map:FlxTilemap):Tower{
		var tower = towers.recycle(Tower);
		var point = Util.toCameraCoordinates(X,Y);
		tower.init(Std.int(point.x), Std.int(point.y),bullets,towerLayers,map);

		return tower;
	}

	public static function addAlly(allies:FlxTypedGroup<Ally>, X:Int, Y:Int, ?player:Player):Ally{
		var ally = allies.recycle(Ally);
		ally.init(X,Y,player);
		return ally;
	}

	public static function addBullet(bullets:FlxTypedGroup<Bullet>, X:Int, Y:Int, GunType:Int, Type:Int){
		var bullet = bullets.recycle(Bullet);
		var attack = 1; 
		switch (GunType) {
			case 0:
				// horizontal only
				bullet.init(X,Y,Type,attack,0);
				bullet = bullets.recycle(Bullet);
				bullet.init(X,Y,Type,attack,180);
			case 1:
				// vertical only
				bullet.init(X,Y,Type,attack,90);
				bullet = bullets.recycle(Bullet);
				bullet.init(X,Y,Type,attack,-90);
			case 2:
				// X only
				bullet.init(X,Y,Type,attack,45);
				bullet = bullets.recycle(Bullet);
				bullet.init(X,Y,Type,attack,-45);
				bullet = bullets.recycle(Bullet);
				bullet.init(X,Y,Type,attack,135);
				bullet = bullets.recycle(Bullet);
				bullet.init(X,Y,Type,attack,-135);
		}
	}

	public static function createHomebase(X:Int, Y:Int, Health:Int):Homebase{
		var point = Util.toCameraCoordinates(X,Y);
		var homebase = new Homebase(Std.int(point.x), Std.int(point.y), Health);
		return homebase;
	}

	public static function addSpawnPoint(spawns:FlxTypedGroup<SpawnArea>,X:Int,Y:Int,enemies:FlxTypedGroup<Enemy>, 
											waves:Array<Array<Int>>):SpawnArea{
		var point = Util.toCameraCoordinates(X,Y);
		var spawnArea = spawns.recycle(SpawnArea);
		spawnArea.init(Std.int(point.x), Std.int(point.y),enemies,waves);
		return spawnArea;
	}

	public static function createPlayer(X:Int, Y:Int, allies:FlxTypedGroup<Ally>):Player{
		var point = Util.toCameraCoordinates(X,Y);
		return new Player(Std.int(point.x), Std.int(point.y),allies);       
	}

}

////////////////////////// Collision
////////////////////////////////////
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
			e._healthBar.kill();
			homebase.hurt(1);
			e.kill();
		}
	}
	private function hitEnemyBullet(e:Enemy, b:Bullet){
		if (e.alive){
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
		if (!t.created && prevCollision != CollisionID.PT){
			// if the player hasn't made a tower here yet
			if (state.subState == null)
				state.openSubState(new BuildState(t));
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

////////////////////////// Game Objects
///////////////////////////////////////
class Player extends FlxSprite{
	public var speed:Int = 100;
	private var allyRange:Int = 100;
	private var allies:FlxTypedGroup<Ally>;
	public function new(X:Int, Y:Int, allies:FlxTypedGroup<Ally>){
		super(X,Y,AssetPaths.gun1__png); // TODO: replace with player specific graphic
		this.allies = allies;
		facing = FlxObject.LEFT;
	}
	override public function update(elapsed:Float){
		super.update(elapsed);
		velocity.x=0;
		velocity.y=0;

		if (FlxG.keys.anyPressed([W,UP])){
			facing = FlxObject.UP;
			velocity.y = -speed;
		}
		if (FlxG.keys.anyPressed([S,DOWN])){
			facing = FlxObject.DOWN;
			velocity.y = speed;
		}
		if (FlxG.keys.anyPressed([A,LEFT])){
			facing = FlxObject.LEFT;
			velocity.x = -speed;
		}
		if (FlxG.keys.anyPressed([D,RIGHT])){
			facing = FlxObject.RIGHT;
			velocity.x = speed;
		}
		if (FlxG.keys.anyJustPressed([SPACE])){
			for (a in allies){
				var distance:Float = getPosition().distanceTo(a.getPosition());
				if (a.alive && !a.inTower && distance <= allyRange){
					a.facing = facing;
					a.target = null;
					break;
				}
			}
		}
	}
}
class Ally extends FlxSprite{
	public var target(default,set):FlxSprite;
	public var inTower:Bool;
	private var speed:Int;
	public function init(X:Int, Y:Int, ?target:Player){
		setPosition(X,Y);
		loadGraphic(AssetPaths.snowman_machine_gun__png);
		this.target = target;
		inTower = false;
	}
	override public function update(elapsed:Float){
		super.update(elapsed);

		// reset v
		velocity.x = velocity.y = 0;

		// follow target algo
		if (target!= null && target.alive)
		{
			FlxVelocity.moveTowardsObject(this, target, speed);
		}else{
			switch (facing) {
				case FlxObject.RIGHT:
					velocity.x = speed;
				case FlxObject.LEFT:
					velocity.x = -speed;
				case FlxObject.UP:
					velocity.y = -speed;
				case FlxObject.DOWN:
					velocity.y = speed;
			 }
		}

	}
	private function set_target(Value:FlxSprite):FlxSprite{
		target = Value;
		if (target != null && Std.is(target,Player))
			speed = Std.int(cast(target,Player).speed*((Std.random(20)+75)/100.));
		return target;
	}
}
class Enemy extends FlxSprite{
	public var attackPt:Int;
	public var attackRange:Int = 64; 
	public var healthPt:Int;
	private var type:Int;
	private var speed:Int;
	private var _prevFacing:Int;
	private var _framerate:Int = 8;

	// path variables
	private var _savedPath:Array<FlxPoint>;
	private var _savedSpeed:Float;
	private var _savedOnComplete:FlxPath->Void;

	// attacking vars
	public var isAttacking:Bool = false; 
	private var _targetTower:Tower;
	private var _attackInterval:Int = 1;
	private var _attackCounter:Int = 0;

	public var _healthBar:FlxBar; 
	
	public function init(X:Int, Y:Int, Type:Int, Attack:Int, Health:Int, Speed:Int){
		setPosition(X,Y);
		type = Type;
		attackPt = Attack;
		healthPt = Health;
		speed = Speed;
		alpha = 1;
		_healthBar = new FlxBar(0, 0, FlxBarFillDirection.LEFT_TO_RIGHT, 30, 4, this, "healthPt", 0, this.healthPt,true);
		_healthBar.trackParent(15, 65);
		FlxG.state.add(_healthBar);
		
		isAttacking = false; 
		// reset path vars
		_savedPath = null;
		_savedSpeed = 0;
		_savedOnComplete = null;
		angle = 0;

		_prevFacing = facing;
	}

	override public function update(elapsed:Float) {
		// what to do during attacking state
		if (isAttacking){
			_attackCounter += Std.int(FlxG.timeScale);

			if (_attackCounter > (_attackInterval * FlxG.updateFramerate)){
				_targetTower.hurt(attackPt);
				_attackCounter = 0;
			}

		 	// stop attacking a dead tower and go back to path
			if (_targetTower!=null && (!_targetTower.alive || !_targetTower.created)){
				// resume path
				resumePath();

				// stop attacking
		 		isAttacking = false;
		 		_targetTower = null;
	 		}
		}

		// update animations based on where we are facing if we changed facing directions
		calculateFacing();
		if (isAttacking){
			animation.play("attack");
		}

		else if (_prevFacing != facing){
			switch (facing){
				case FlxObject.DOWN:
					this.animation.play("walk_down");
				case FlxObject.UP:
					this.animation.play("walk_up");
				case FlxObject.LEFT:
					this.animation.play("walk_left");
				case FlxObject.RIGHT:
					this.animation.play("walk_right");
				default:
					this.animation.play("walk_right");
			}
		}

		_prevFacing = facing;

		super.update(elapsed);


	}

	override public function hurt(Damage:Float){
		healthPt -= Std.int(Damage);
		alpha -= 0.05;

		if (healthPt <= 0){
			kill();
			_healthBar.kill();
		}
	}

	private function calculateFacing():Int{
	 	if (velocity.x < 0)
	 		facing = FlxObject.LEFT;
	 	else if (velocity.x > 0) {
	 		facing = FlxObject.RIGHT;
	 	}
	 	else if (velocity.y < 0)
	 		facing = FlxObject.UP;
	 	else if (velocity.y > 0)
	 		facing = FlxObject.DOWN;
	 	else
	 		facing = FlxObject.NONE;

	 	return facing; 
	 }

	/**
	 * Start this enemy on a path, as represented by an array of FlxPoints. Updates position to the first node
	 * and then uses FlxPath.start() to set this enemy on the path. Speed is determined by wave number, unless
	 * in the menu, in which case it's arbitrary.
	 */
	public function followPath(Path:Array<FlxPoint>):Void
	{
		if (Path == null)
			throw("No valid path was passed to the enemy! Does the tilemap provide a valid path from start to finish?");
		
		Path[0].x = x;
		Path[0].y = y;
		
		path = new FlxPath().start(Path, speed, 0, false);
	}


	public function pausePath():Void{
		_savedSpeed = path.speed;
		_savedOnComplete = path.onComplete;
		_savedPath = Util.copyPathFrom(path.nodes, path.nodeIndex);
		_savedPath.insert(0, getMidpoint());
		path.cancel();
		path = null;
	}

	public function resumePath():Void{
 		path = new FlxPath().start(_savedPath, _savedSpeed, 0, false);
		path.onComplete = _savedOnComplete;
		_savedPath = null;
		_savedSpeed = 0;
		_savedOnComplete = null;
	}

	/**
	 *	Starts attacking the tower that is within range until it has died
	 */
	 public function attack(tower:Tower):Void{
	 	if (tower!=null && tower.alive){
	 		// keep attacking the tower at set intervals
	 		isAttacking = true;

	 		// TODO: add attacking animation play here
	 		_targetTower = tower;

	 		pausePath();
	 	}
	 }

}
class SpawnArea extends FlxTypedGroup<FlxSprite>{
	public var midpoint:FlxPoint;
	public var gameover:Bool;
	public var playerReady:Bool;

	public var currentEnemy:Int;
	public var currentWave:Int;
	public var goal:FlxPoint;
	public var map:FlxTilemap;

	private var defaultPath: Array<FlxPoint>;

	private var interval:Int = 1;
	private var counter:Int;
	private var waves:Array<Array<Int>>;
	private var enemies:FlxTypedGroup<Enemy>;
	
	public var waveComplete:Bool;
	public var waveStart:Bool;
	
	public function init(X:Int,Y:Int, enemies:FlxTypedGroup<Enemy>, Waves:Array<Array<Int>>){

		// make 9 forest around spawn point tile
		var forest:FlxSprite;
		for (y in -1...2){
			for (x in -1...2){
				forest = new FlxSprite();
				forest.loadGraphic(AssetPaths.forest__png,false,Util.TILE_SIZE,Util.TILE_SIZE);
				forest.setPosition(X+x*Util.TILE_SIZE,Y+y*Util.TILE_SIZE);
				add(forest);
			}
		}

		// set the mid point of the forest. X and Y are the location of the center forest
		midpoint = new FlxPoint(X,Y);
		gameover = false;
		playerReady = false;

		counter = 0;
		waves = Waves;
		currentWave = 0;
		currentEnemy = 0;
		this.goal = new FlxPoint(X, Y);
		this.map = null; 
		this.enemies = enemies;
		waveComplete = false;
		waveStart = true;

	}
	override public function update(elapsed:Float){
		super.update(elapsed);
		if (gameover || !playerReady)
			return;

		counter += Std.int(FlxG.timeScale);
		if (counter > interval * FlxG.updateFramerate && currentWave < waves.length && waves[currentWave].length > currentEnemy)
		{
			
			var path = map.findPath(midpoint, goal.copyTo());
			if (path == null) {
				path = Util.copyPathFrom(defaultPath, 0); 
			}
			GameObjectFactory.addEnemy(enemies, Std.int(midpoint.x), Std.int(midpoint.y), waves[currentWave][currentEnemy],path);
			counter = 0;
			currentEnemy ++;
			
		}
		else if (currentEnemy >= waves[currentWave].length) {
			if (enemies.countLiving() == 0)
				waveComplete = true;
		}
		
		if (waveComplete && currentWave <= waves.length - 1) {
			currentWave ++;
			currentEnemy = 0;
			waveComplete = false;
			waveStart = true;
		}

		if (currentEnemy >= waves[waves.length-1].length && currentWave >= waves.length - 1)
			gameover = true;
	}

	public function computeDefaultPath(): Void { 
		this.defaultPath = map.findPath(midpoint, goal.copyTo());
	}

}
class Bullet extends FlxSprite{
	public var attackPt:Int;
	public var type:Int;
	private var speed:Int;
	public function init(X:Int,Y:Int,Type:Int,Attack:Int,Angle:Int){
		switch (Type) {
			case 6:
				loadGraphic(AssetPaths.snowball__png);
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
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// get rid of off screen bullet or a too transparent bullet
		if (!isOnScreen(FlxG.camera) || alpha <= 0.8) 
		{
			super.kill();
		}
		
		alpha -= 0.005;
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
		var midpoint = getMidpoint();
		for (m in materials){
			if (m < 6){
				// materials
				var layer = new FlxSprite();
				switch (m) {
					// gunbases
					case 0:
						layer.loadGraphic(AssetPaths.snowman_head__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						gunTypes.push(m);
					case 1:
						layer.loadGraphic(AssetPaths.snowman_machine_gun__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						gunTypes.push(m);
					case 2:
						layer.loadGraphic(AssetPaths.snowman_spray__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						gunTypes.push(m);

					// foundations
					case 3:
						layer.loadGraphic(AssetPaths.snow1__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 1; 

					case 4:
						layer.loadGraphic(AssetPaths.snowman_ice__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 2; 

					case 5:
						layer.loadGraphic(AssetPaths.snowman_coal__png);
						layer.setPosition(midpoint.x-layer.width/2, midpoint.y-layer.height/2 + yOffset);
						towerLayers.add(layer);
						health += 3; 
				}

				children.push(layer);
				yOffset -= 32;
			}else{
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
			created = false; 
			_healthBar.visible = false;
			_healthBar.kill();
			for (c in children)
				c.kill();
			var savedWorkers = workers;
			init(Std.int(x), Std.int(y), bullets, towerLayers, map);
			workers = savedWorkers;
			map.setTile(Std.int(getMidpoint().x / Constants.TILE_SIZE), Std.int(getMidpoint().y / Constants.TILE_SIZE), 0, false);
		}
	}
}
class Homebase extends FlxGroup{
	private static inline var xOffset:Int=-5;
	private static inline var yOffset:Int=-20;
	private static inline var gap:Int=15;

	public var point:FlxPoint;
	public var midpoint:FlxPoint;
	public var gameover:Bool;
	public var health(default, set):Int;

	private var healthSprites:FlxTypedGroup<FlxSprite>;
	public function new(X:Int, Y:Int, Health:Int){
		super();

		// init stats
		gameover = false;
		health = Health;

		// make homebase
		var homebase = new FlxSprite(X,Y, AssetPaths.homebase__png);
		var diffW = homebase.width - Util.TILE_SIZE;
		var diffH = homebase.height - Util.TILE_SIZE;
		homebase.setPosition(X - diffW/2, Y - diffH/2);
		add(homebase);

		midpoint = homebase.getMidpoint();
		point = new FlxPoint(X,Y);

		// make hearts around homebase to show life
		// max life is 5
		healthSprites = new FlxTypedGroup<FlxSprite>();
		for (h in 0...health)
		{
			var heart = new FlxSprite(X+xOffset + gap * h, Y+yOffset);
			heart.loadGraphic(AssetPaths.heart__png, true, 16, 16);
			heart.animation.add("beating",[0,1,2,1,0,0,0,0,0,0,0],10,true);
			heart.animation.play("beating");
			healthSprites.add(heart);
		}
		add(healthSprites);
	}

	override public function update(elapsed:Float){
		super.update(elapsed);
		healthSprites.update(elapsed);
	}

	public function hurt(damage:Int){
		health -= damage;
		if (health <= 0){
			gameover = true;
			kill();
		}
	}

	private function set_health(Health:Int):Int{
		if (health >= 0 && health > Health)
			healthSprites.members[Health].kill();
		if (health < Health){
			var h = healthSprites.recycle(FlxSprite);
			h.reset(point.x+xOffset + gap * (Health-1), point.y+yOffset);
		}

		health = Health;
		return health;
	}
}


////////////////////////// State
////////////////////////////////

class BuildState extends FlxSubState{
	private var MAX_TOWER_HEIGHT = 3;
	private var _tower:Tower;
	private var _materials:Array<Int>;
	private var currentStack:Int;
	private var ammo:Int;
	private var ammoSprite:FlxSprite;
	private var gui:FlxTypedGroup<FlxSprite>;
	private var display:FlxTypedGroup<FlxSprite>;
	private var storePosition:FlxPoint;
	public function new(tower:Tower){
		super();
		_tower = tower;
	}
	override public function create():Void
	{
		super.create();
		currentStack = 500;
		this.ammo = 6;
		_materials = new Array<Int>();
		gui = new FlxTypedGroup<FlxSprite>();
		storePosition = new FlxPoint(FlxG.width - 340, 40);
		MAX_TOWER_HEIGHT = LevelData.getCurrentLevel().buildLimit;

		// semi transparent black bg overlay
		var background = new FlxSprite(Std.int(storePosition.x),0);
		background.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		background.alpha = 0.5;
		gui.add(background);

		// store bg
		var store = new FlxSprite(Std.int(storePosition.x+20),Std.int(storePosition.y));
		store.loadGraphic(AssetPaths.storewithtextnoammo__png);
		gui.add(store);

		// add buttons vars
		var gap = 10; 
		var width = 50; 
		var height = 67; 
		var x = FlxG.width-260;
		var y = 145;
		var row = 0; 
		var col = -1;
		var buttons = LevelData.getCurrentLevel().buttonTypes;
		var tutPos = new FlxPoint(x+col*(width+gap), y+row*(height+gap));

		// row of gun buttons
		var gun:FlxButton;
		if (buttons.indexOf(0) != -1){
			col++;
			gun = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", gunCallback.bind(0));
			gun.loadGraphic(AssetPaths.SnowyGunBase__png, true, width, height); 
			gui.add(gun);
		}

		if (buttons.indexOf(1) != -1){
			col++;
			gun = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", gunCallback.bind(1));
			gun.loadGraphic(AssetPaths.SpeedyGunBase__png, true, width, height); 
			gui.add(gun);
		}
		
		if (buttons.indexOf(2) != -1){
			col++;
			gun = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", gunCallback.bind(2));
			gun.loadGraphic(AssetPaths.SpatterGunBase__png, true, width, height); 
			gui.add(gun);
		}

		row++;
		col = -1;

		// row of foundation buttons
		var foundation:FlxButton;
		if (buttons.indexOf(3) != -1){
			col++;
			foundation = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", foundationCallback.bind(3));
			foundation.loadGraphic(AssetPaths.SnowBase__png, true, width, height); 
			gui.add(foundation);
		}

		if (buttons.indexOf(4) != -1){
			col++;
			foundation = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", foundationCallback.bind(4));
			foundation.loadGraphic(AssetPaths.IceBase__png, true, width, height); 
			gui.add(foundation);
		}
		
		if (buttons.indexOf(5) != -1){
			col++;
			foundation = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", foundationCallback.bind(5));
			foundation.loadGraphic(AssetPaths.CoalBase__png, true, width, height); 
			gui.add(foundation);
		}

		row++;
		col = -1;

		// row of ammo buttons
		var ammo:FlxButton;
		if (buttons.indexOf(6) != -1){
			col++;
			ammo = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", ammoCallback.bind(6));
			ammo.loadGraphic(AssetPaths.PiercingAmmoButton__png, true, width, height); 
			gui.add(ammo);
		}

		if (buttons.indexOf(7) != -1){
			col++;
			ammo = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", ammoCallback.bind(7));
			ammo.loadGraphic(AssetPaths.ExplodeAmmoButton__png, true, width, height); 
			gui.add(ammo);
		}
		
		if (buttons.indexOf(8) != -1){
			col++;
			ammo = new FlxButton(x+col*(width+gap), y+row*(height+gap), "", ammoCallback.bind(8));
			ammo.loadGraphic(AssetPaths.FreezeAmmoButton__png, true, width, height); 
			gui.add(ammo);
		}

		// sprite to display the selected ammo
		ammoSprite = new FlxSprite(Std.int(storePosition.x)+100,460,AssetPaths.snowball__png);
		gui.add(ammoSprite);

		add(gui);

		// used for displaying the currently created tower
		display = new FlxTypedGroup<FlxSprite>();
		add(display);

		// add deny and confirm buttons
		var but:FlxButton = new FlxButton(Std.int(storePosition.x) + 100, FlxG.height - 100, "", confirmedCallback);
		but.loadGraphic(AssetPaths.confirmButton__png, true, 50, 50); 
		gui.add(but);

		but = new FlxButton(Std.int(storePosition.x) +200, FlxG.height - 100, "", exitCallback);
		but.loadGraphic(AssetPaths.denyButton__png, true, 50, 50); 
		gui.add(but);

		// tutorial related events
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 0){
			FlxG.state.remove(GameState.tutorialArrow);
			GameState.tutorialArrow.visible = true;
			GameState.tutorialArrow.setPosition(Std.int(tutPos.x)+20, Std.int(tutPos.y));
			gui.add(GameState.tutorialArrow);
			GameState.tutorialEvent++;
		}

		// move all gui elements outside of screen and stop their scroll factors
		var xOffset = FlxG.width;
		for (e in gui){
			e.x+=xOffset;
			e.scrollFactor.set(0,0);
		}

		// add move in tween
		for (e in gui){
			FlxTween.tween(e, { x: e.x-xOffset }, 0.5, { ease: FlxEase.expoOut });
		}
	}

	override public function add(Object:FlxBasic):FlxBasic{
		var result = super.add(Object);
		// needed to prevent camera scrolling from affecting this state
		if (Std.is(Object, FlxObject)){
			cast(Object, FlxObject).scrollFactor.set(0,0);
		}

		return result;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([Y])) {
			confirmedCallback();
		}
		if (FlxG.keys.anyJustPressed([N,P]) || (FlxG.mouse.justPressed && FlxG.mouse.x < storePosition.x)) {
			exitCallback();
		}

		// log mouse clicks
		if(FlxG.mouse.justReleased){
			var logString = "Level:"+LevelData.currentLevel+" X:"+FlxG.mouse.x+" Y:"+FlxG.mouse.y;
			Logging.recordEvent(2, logString);
		}
		if(FlxG.mouse.justPressed){
			var logString = "Level:"+LevelData.currentLevel+" X:"+FlxG.mouse.x+" Y:"+FlxG.mouse.y;
			Logging.recordEvent(1, logString);
		}
	}

	private function confirmedCallback(){
		// tutorial related
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 2){
			GameState.tutorialArrow.visible = false;
			gui.remove(GameState.tutorialArrow);
			GameState.tutorialEvent++;
		}

		_materials.push(ammo);
		_tower.buildTower(_materials);
		exitCallback();
	}

	private function exitCallback(){
		// reset tutorial
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent <= 2){
			gui.remove(GameState.tutorialArrow);
			FlxG.state.add(GameState.tutorialArrow);
			var tutPos = Util.toMapCoordinates(_tower.x,_tower.y);
			tutPos = Util.toCameraCoordinates(Std.int(tutPos.x - 1), Std.int(tutPos.y));
			GameState.tutorialArrow.setPosition(Std.int(tutPos.x)+GameState.tutorialArrow.width/2, 
				Std.int(tutPos.y));
			GameState.tutorialArrow.visible = true;
			GameState.tutorialEvent=0;			
		}

		for (e in display)
			FlxTween.tween(e, { x: e.x+FlxG.width }, 0.5, { ease: FlxEase.expoIn, onComplete: function(t) close() });
		for(e in gui)
			FlxTween.tween(e, { x: e.x+FlxG.width }, 0.5, { ease: FlxEase.expoIn, onComplete: function(t) close() });
	}

	private function gunCallback(type:Int){
		// tutorial 
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 1){
			GameState.tutorialArrow.setPosition(Std.int(storePosition.x)+50, FlxG.height - 100);
			GameState.tutorialEvent++;
		}

		// main
		if (addMaterial(type)){
			var temp = new FlxSprite(Std.int(storePosition.x)+150,currentStack);
			switch(type){
				case 0:
					temp.loadGraphic(AssetPaths.snowman_head__png);
				case 1:
					temp.loadGraphic(AssetPaths.snowman_machine_gun__png);
				case 2:
					temp.loadGraphic(AssetPaths.snowman_spray__png);
			}
			currentStack -= 32;
			display.add(temp);
		}
	}
	private function foundationCallback(type:Int){
		if (addMaterial(type)){
			var temp = new FlxSprite(Std.int(storePosition.x)+150,currentStack);
			switch(type){
				case 3:
					temp.loadGraphic(AssetPaths.snow1__png);
				case 4:
					temp.loadGraphic(AssetPaths.snowman_ice__png);
				case 5:
					temp.loadGraphic(AssetPaths.snowman_coal__png);
			}
			currentStack -= 32;
			display.add(temp);
		}
	}
	private function ammoCallback(type:Int){
		switch(type){
			case 6:
				ammoSprite.loadGraphic(AssetPaths.snowball__png);
			case 7:
				ammoSprite.loadGraphic(AssetPaths.snowball2__png);
			case 8:
				ammoSprite.loadGraphic(AssetPaths.snowball3__png);
		}
		ammo = type;
	}
	private function addMaterial(type:Int):Bool{
		if (_materials.length < MAX_TOWER_HEIGHT){
			_materials.push(type);
			return true;
		}

		trace('cannot add more material to tower... tower already has $_materials');
		return false;
	}
}

class PauseState extends FlxSubState
{   
	override public function create():Void
	{
		super.create();
		var background = new FlxSprite(0,0);
		background.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);

		var text = new flixel.text.FlxText(0, 0, 0, "Paused", 64);
		text.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text.screenCenter();
		add(text);

		var text2 = new flixel.text.FlxText(0, 0, 0, "press [P] to resume, [R] to restart, or [Q] to exit", 32);
		text2.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text2.screenCenter();
		text2.y += 40;
		add(text2);
	}

	override public function add(Object:FlxBasic):FlxBasic{
		var result = super.add(Object);
		// needed to prevent camera scrolling from affecting this state
		if (Std.is(Object, FlxObject)){
			cast(Object, FlxObject).scrollFactor.set(0,0);
		}

		return result;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([P])) {
			close();		
		}
		if (FlxG.keys.anyJustPressed([Q]))
			FlxG.switchState(new LevelSelectState());   
		if (FlxG.keys.anyJustPressed([R])) {
			if (LevelData.currentLevel == 0)
				GameState.tutorialEvent = 0;
			FlxG.switchState(new GameState());
		}
	}	
}

class LoseState extends FlxSubState
{   
	override public function create():Void
	{
		super.create();
		var background = new FlxSprite(0,0);
		background.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);

		var text = new flixel.text.FlxText(0, 0, 0, "Game Over", 64);
		text.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text.screenCenter();
		add(text);

		var text2 = new flixel.text.FlxText(0, 0, 0, "press [R] to restart or [Q] to exit", 32);
		text2.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text2.screenCenter();
		text2.y += 40;
		add(text2);
	}

	override public function add(Object:FlxBasic):FlxBasic{
		var result = super.add(Object);
		// needed to prevent camera scrolling from affecting this state
		if (Std.is(Object, FlxObject)){
			cast(Object, FlxObject).scrollFactor.set(0,0);
		}

		return result;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([Q]))
			FlxG.switchState(new LevelSelectState());
		if (FlxG.keys.anyJustPressed([R]))
			FlxG.switchState(new GameState());
	}   
}

class WinState extends FlxSubState
{   
	override public function create():Void
	{
		super.create();
		var background = new FlxSprite(0,0);
		background.makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
		background.alpha = 0.5;
		add(background);

		var text = new flixel.text.FlxText(0, 0, 0, "Level Cleared!", 64);
		text.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text.screenCenter();
		add(text);

		var text2 = new flixel.text.FlxText(0, 0, 0, "press [R] to restart, [N] for next level, or [Q] to exit", 20);
		text2.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text2.screenCenter();
		text2.y += 40;
		add(text2);

		// unlock next level
		LevelData.gotoNextLevel();
		LevelData.currentLevel--;
	}

	override public function add(Object:FlxBasic):FlxBasic{
		var result = super.add(Object);
		// needed to prevent camera scrolling from affecting this state
		if (Std.is(Object, FlxObject)){
			cast(Object, FlxObject).scrollFactor.set(0,0);
		}

		return result;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([Q]))
			FlxG.switchState(new LevelSelectState());
		if (FlxG.keys.anyJustPressed([R]))
			FlxG.switchState(new GameState());
		if (FlxG.keys.anyJustPressed([N])){
			if (LevelData.gotoNextLevel() == null)
				FlxG.switchState(new LevelSelectState());
			FlxG.switchState(new GameState());
		}
	}   
}

class GameState extends FlxState{
	public static var tutorialEvent:Int = 0;
	public static var tutorialArrow:FlxSprite;

	private var _level:Level;
	private var map:FlxTilemap;
	private var enemies:FlxTypedGroup<Enemy>;
	private var spawns:FlxTypedGroup<SpawnArea>;
	private var homebase:Homebase;
	private var player:Player;
	private var collisionController:CollisionController;
	public var healthBars = new FlxTypedGroup<FlxBar>();
	private var _centerText:FlxText;

	public static var abTestVersion = Logging.assignABTestValue(FlxG.random.int(1,2));
	public static var isATesting = abTestVersion <= 1;

	override public function create(){
		super.create();
		FlxG.timeScale = 1;
		if (isATesting)
			persistentUpdate = true;

		// init flx group vars
		var towers = new FlxTypedGroup<Tower>();
		var towerLayers = new FlxTypedGroup<FlxSprite>();
		this.enemies = new FlxTypedGroup<Enemy>();
		var bullets = new FlxTypedGroup<Bullet>();
		var allies = new FlxTypedGroup<Ally>();
		spawns = new FlxTypedGroup<SpawnArea>();

		// get level data
		_level = LevelData.getCurrentLevel();
		var mapArray = Util.loadCSV(_level.mapFilepath);

		// log the start of this level
		Logging.recordLevelEnd();
		Logging.recordLevelStart(LevelData.currentLevel);

		// make game objects from level data
		var originalMap = new FlxTilemap();
		var towerMap = new FlxTilemap();
		var mapWidth = mapArray[0].length;
		var mapHeight = mapArray.length;
		for (row in 0...mapHeight){
			for (col in 0...mapWidth){
				switch (mapArray[row][col]) {
					case 0:
						continue;
					case 1:
						continue;
					case 2:
						// create spawn point and then remove it from map
						GameObjectFactory.addSpawnPoint(spawns,col,row,enemies,_level.waves);
						mapArray[row][col] = 0; // remove it
					case 3:
						// create homebase and remove it from map
						homebase = GameObjectFactory.createHomebase(col,row,_level.startHealth);
						mapArray[row][col] = 0; // remove it
					case 4:
						// create player and remove it from map
						player = GameObjectFactory.createPlayer(col,row,allies);
						mapArray[row][col] = 0; //remove it
					case 5:
						// create tower placeholder
						GameObjectFactory.addTower(towers, col, row, bullets, towerLayers,towerMap);
						mapArray[row][col] = 0; // remove it
					case 6:
						// create ally
						GameObjectFactory.addAlly(allies, col*Util.TILE_SIZE, row*Util.TILE_SIZE);
						mapArray[row][col] = 0; // remove it
					default:
						mapArray[row][col] = 0; // remove it
				}
			}
		}

		// load the map
		originalMap.loadMapFrom2DArray(mapArray, _level.tilemap, Util.TILE_SIZE,Util.TILE_SIZE, AUTO);
		towerMap.loadMapFrom2DArray(Util.copy2DArray(mapArray), _level.tilemap, Util.TILE_SIZE,Util.TILE_SIZE, AUTO);
		this.map = originalMap;

		// set goal for spawn point and pass the map to spawn area
		var goal = homebase.midpoint;
		for (spawnArea in spawns){
			spawnArea.goal = new FlxPoint(goal.x,goal.y);
			spawnArea.map = towerMap;
			spawnArea.computeDefaultPath();
		} 

		// update allies to follow player
		for(a in allies){
			a.target = player;
		}


		// collision setup
		collisionController = new CollisionController(originalMap, towerMap, player, allies, 
								enemies, bullets, towers, homebase, spawns, this);
								
		
		// center text
		_centerText = new FlxText( -200, 50, FlxG.width, "", 32);
		_centerText.alignment = CENTER;
		_centerText.borderStyle = SHADOW;
		_centerText.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);

		// add all objects to screen
		add(originalMap);
		add(spawns);
		add(towers);
		add(allies);
		add(enemies);
		add(bullets);
		add(towerLayers);

		if (player != null)
			add(player);
		else{
			var center = Util.toMapCoordinates(FlxG.width/2, FlxG.height/2);
			player = GameObjectFactory.createPlayer(Std.int(center.x),Std.int(center.y),allies);
			player.exists = false;

			// add dummy worker to each tower if there is no player
			for (t in towers)
				t.addWorker(GameObjectFactory.dummyAlly);
		}
		add(homebase);
		add(_centerText);


		// camera setup
		var LEVEL_MIN_X = 0;
		var LEVEL_MIN_Y = 0;
		var LEVEL_MAX_X = Util.TILE_SIZE*mapWidth;
		var LEVEL_MAX_Y = Util.TILE_SIZE*mapHeight;
		FlxG.cameras.bgColor = FlxColor.fromInt(0xff85bbff);
		FlxG.camera.setScrollBoundsRect(LEVEL_MIN_X, LEVEL_MIN_Y,
			LEVEL_MAX_X + Math.abs(LEVEL_MIN_X), LEVEL_MAX_Y + Math.abs(LEVEL_MIN_Y), true);
		FlxG.camera.follow(player, LOCKON, 0.5);
	
		// tutorial related setup
		GameState.tutorialArrow = new FlxSprite(0,0);
		GameState.tutorialArrow.loadGraphic(AssetPaths.SmallArrow__png, true, 34, 50);
		GameState.tutorialArrow.animation.add("play", [0,1,2,3], 5, true);
		GameState.tutorialArrow.animation.play("play");
		GameState.tutorialArrow.visible = false;
		GameState.tutorialArrow.angle = 90;
		add(GameState.tutorialArrow);
		if (LevelData.currentLevel == 0 && GameState.tutorialEvent == 0){
			var randomTower = towers.getFirstAlive();
			var tutPos = Util.toMapCoordinates(randomTower.x,randomTower.y);
			tutPos = Util.toCameraCoordinates(Std.int(tutPos.x - 1), Std.int(tutPos.y));
			GameState.tutorialArrow.setPosition(Std.int(tutPos.x)+GameState.tutorialArrow.width/2, 
				Std.int(tutPos.y));
			GameState.tutorialArrow.visible = true;
		}
	}
	
	override public function update(elapsed:Float){
		super.update(elapsed);

		// keyboard shortcuts
		if (FlxG.keys.anyJustPressed([P, Q])) {
			if (isATesting)
				persistentUpdate = false;
			openSubState(new PauseState());
		} else {
			if (isATesting)
				persistentUpdate = true;
		}

		// log mouse clicks
		if(FlxG.mouse.justReleased){
			var logString = "Level:"+LevelData.currentLevel+" X:"+FlxG.mouse.x+" Y:"+FlxG.mouse.y;
			Logging.recordEvent(2, logString);
		}
		if(FlxG.mouse.justPressed){
			var logString = "Level:"+LevelData.currentLevel+" X:"+FlxG.mouse.x+" Y:"+FlxG.mouse.y;
			Logging.recordEvent(1, logString);
		}

		// update interactions of game objects
		collisionController.update(elapsed);
		
		var waveStart = true;
		var playerReady = true;
		for (spawnArea in spawns){
			if (!spawnArea.waveStart)
				waveStart = false;

			if (!spawnArea.playerReady)
				playerReady = false;
		}

		if (waveStart && playerReady) {
			announceWave();
			for (spawnArea in spawns){
				spawnArea.waveComplete = false;
				spawnArea.waveStart = false;
			}
		}

		add(healthBars);

		if (!player.exists)
			player.update(elapsed);

		// last thing to do on update
		checkGameOver();
	}
	
	/*	
	*	Announces start of new wave.
	*/
	private function announceWave():Void {
		
		_centerText.x = -200;
		_centerText.text = "Wave " + (spawns.getFirstAlive().currentWave + 1);
		
		FlxTween.tween(_centerText, { x: 0 }, 2, { ease: FlxEase.expoOut, onComplete: hideText });
		
	}
	private function hideText(Tween:FlxTween):Void {
		FlxTween.tween(_centerText, { x: FlxG.width }, 2, { ease: FlxEase.expoIn });
	}

	/*  Checks whether or not the game is over.
	*   If it is over then envoke either a win screen or lose screen
	*/
	private function checkGameOver(){
		// if you lost the game then open LoseState, then return
		if (homebase.gameover || !player.alive || homebase.health <= 0){
			var logString = "Wave Num:"+spawns.getFirstAlive().currentWave+" Level:"+LevelData.currentLevel;
			Logging.recordEvent(6, logString);
			if (isATesting)
				persistentUpdate = false;
			openSubState(new LoseState());
			return;
		}

		// if you won the game then open WinState and record win
		var alive = 0;
		for (e in enemies){
			if (e.alive)
				alive++;
		}
		var gameover = true;
		for (spawnArea in spawns){
			if (!spawnArea.gameover)
				gameover = false;
		}
		if (gameover && alive == 0){
			var logString = "Level:"+LevelData.currentLevel;
			Logging.recordEvent(7, logString);

			if (isATesting)
				persistentUpdate = false;
			
			if (LevelData.currentLevel == 0) {
				if (LevelData.gotoNextLevel() == null)
					FlxG.switchState(new MenuState());
				FlxG.switchState(new GameState());
			}
			else {
				openSubState(new WinState());
			}
		}
	}
}