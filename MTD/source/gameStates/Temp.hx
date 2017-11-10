package gameStates;

import flixel.FlxState;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;

////////////////////////// Level
////////////////////////////////
typedef Level{
	var mapFilepath:String;
	var tilemap:String;
	var startHealth:Int;
	var waves:Array<Array<Int>>;
}

class LevelData{
	public static var level1:Level = {
		mapFilepath:"assets/maps/test.csv",
		tilemap:"assets/tiles/auto_tilemap.png",
		startHealth:5,
		waves:[[0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
				[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]]
	}

	public static var levels = [level1];
	public static var currentLevel = 0;
	public static function getCurrentLevel():Nullable<Level>{
		if (currentLevel>=levels.length){
			trace("Error: Level "+currentLevel+" does not exists");
			return null;
		}
		return levels[currentLevel];
	}
	public static function getNextLevel():Nullable<Level>{
		currentLevel ++;
		return getCurrentLevel();
	}
}

////////////////////////// Util
/////////////////////////////////

class Util{
	public static function loadCSV(MapData:String):Array<Array<Int>>{
		var _data:Array<Array<Int>>;

		// path to map data file?
		if (Assets.exists(MapData))
		{
			MapData = Assets.getText(MapData);
		}
		
		// Figure out the map dimensions based on the data string
		_data = new Array<Array<Int>>;
		var columns:Array<String>;
		
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
		var lines:Array<String> = regex.split(MapData);
		var rows:Array<String> = lines.filter(function(line) return line != "");
		
		for (rowString in row)
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
					throw 'String in row $row, column $column is not a valid integer: "$columnString"';
				
				row.push(curTile);
			}

			_data.push(row);
		}

		return _data;
	}
}

////////////////////////// Constant
////////////////////////////////////////

class GameObjectFactory{
	public static function addEnemy(enemies:FlxTypedGroup<Enemy>, X:Int, Y:Int, Type:Int, Path:FlxPath){
		var enemy = enemies.recycle(Enemy);	// uses an already added enemy, or makes a new one and adds it to enemies

		// make enemy based on type
		switch (Type) {
			case 0:
				enemy.init(X,Y,Type,1,2,100);
				enemy.loadGraphic(AssetPaths.enemy1_spritesheet_64x64__png, true, 64, 64);
			case 1:
				enemy.init(X,Y,Type,2,10,50);
				enemy.loadGraphic(AssetPaths.enemy2_spritesheet_64x64__png, true, 64, 64);
			default:
				trace("No such enemy type: "+ type);
		}

		// set a path for the enemies to follow
		enemy.followPath(Path, Speed);
	}

	public static function createHomebase(X:Int, Y:Int, Health:Int):Homebase{
		var homebase = new Homebase(X,Y,Health);
		return homebase;
	}
}

////////////////////////// Collision
////////////////////////////////////

class CollisionController{
	private map:FlxTilemap;
	private player:Player;
	private enemies:FlxTypedGroup<Enemy>;
	private allies:FlxTypedGroup<Ally>;
	private bullets:FlxTypedGroup<Bullet>;
	private towers:FlxTypedGroup<Tower>;
	private homebase:Homebase;
	private spawnArea:FlxTypedGroup<FlxSprite>;
	public function new(map:FlxTilemap, player:Player, allies:FlxTypedGroup<Ally>,
						enemies:FlxTypedGroup<Enemy>, bullets:FlxTypedGroup<Bullet>, towers:FlxTypedGroup<Tower>,
						homebase:FlxTypedGroup<FlxSprite>, spawnArea:FlxTypedGroup<FlxSprite>){
		this.map = map;
		this.player = player;
		this.allies = allies;;
		this.enemies = enemies;
		this.bullets = bullets;
		this.towers = towers;
		this.homebase = homebase;
		this.spawnArea = spawnArea;
	}

	override public function update(elapsed:Float){
		super.update(elapsed);

		// enemy interactions
		FlxG.overlap(enemies, homebase, hitEnemyHomebase);
		FlxG.overlap(enemies, bullets, hitEnemyBullet);

		// ally interactions
		FlxG.overlap(allies, enemies, hitAllyEnemy);
		FlxG.overlap(allies, towers, hitAllyTower);
		FlxG.overlap(allies, homebase, hitAllyHomebase);
		FlxG.collide(map, allies);

		// player interactions
		FlxG.overlap(player, homebase, hitPlayerHomebase);
		FlxG.overlap(player, enemies, hitPlayerEnemy);
		FlxG.overlap(player, towers, hitPlayerTower);
		FlxG.collide(map, player);
	}
	private function hitEnemyHomebase(e:Enemy, obj:FlxSprite){
		if (e.alive){
			homebase.health -= e.attackPt;
		}
	}
	private function hitEnemyBullet(){}
	private function hitAllyEnemy(){}
	private function hitAllyTower(){}
	private function hitAllyHomebase(){}
	private function hitPlayerHomebase(){}
	private function hitPlayerEnemy(){}
	private function hitPlayerTower(){}
}

////////////////////////// Game Objects
///////////////////////////////////////
class Enemy extends FlxSprite{
	private var type:Int;
	private var attackPt:Int;
	private var healthPt:Int;
	private var speed:Int;
	private var prevFacing:Int;
	public function init(X:Int, Y:Int, Type:Int, Attack:Int, Health:Int, Speed:Int){
		x = X;
		y = Y;
		type = Type;
		attackPt = Attack;
		healthPt = Health;
		speed = Speed;

		// add animation 
		animation.add("idle",[0],_framerate, false);
		animation.add("walk_down",[0,1,2,3,4],_framerate, true);
		animation.add("walk_left",[5,6,7,8,9],_framerate, true);
		animation.add("walk_right",[10,11,12,13,14],_framerate, true);
		animation.add("walk_up",[15,16,17,18,19],_framerate, true);
		animation.play("idle");

		_prevFacing = facing;
	}

	public function followPath(Path:FlxPath, Speed:Int){
		if (Path == null)
			throw("No valid path was passed to the enemy! Does the tilemap provide a valid path from start to finish?");
		
		Path[0].x = x;
		Path[0].y = y;
		
		path = new FlxPath().start(Path, Speed, 0, false);
	}
}
class Bullet extends FlxSprite{
	
}
class Tower extends FlxSprite{
	
}
class Homebase extends FlxTypedGroup<FlxSprite>{
	public var health(default, set):Int;
	private var healthSprites:FlxTypedGroup<FlxSprite>;
	public function new(X:Int, Y:Int, Health:Int){
		// init stats
		health = Health;

		// make homebase
		var homebase = new FlxSprite(X,Y, AssetPaths.homebase__png);
		add(homebase);

		// make hearts around homebase to show life
		// max life is 5
		healthSprites = new FlxGroup();
		var xOffset = 0;
		var yOffset = -20;
		var gap = 20;
		for (h in 0...health)
		{
			var heart = new FlxSprite(xOffset + gap * h, yOffset);
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

	private static function set_health(Health:Int):Int{
		if (health >= 0 && health > Health)
			healthSprites.members[Health].kill();

		health = Health;
		return health;
	}
}


////////////////////////// State
////////////////////////////////
class Temp{
	public function new(){}
}

class BuildState extends FlxSubstate
{	
	override public function create():Void
	{
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}	
}

class PauseState extends FlxSubstate
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

		var text2 = new flixel.text.FlxText(0, 0, 0, "press [P] to resume", 32);
		text2.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text2.screenCenter();
		text2.y += 40;
		add(text2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([P])) {
			close();
		}
	}	
}

class LoseState extends FlxSubstate
{	
	private var _level:Level;
	public function new(level:Level){
		super();
		_level = level;
	}

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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([Q]))
			FlxG.switchState(new MenuState());
		if (FlxG.keys.anyJustPressed([R]))
			FlxG.switchState(new GameState(_level));
	}	
}

class WinState extends FlxSubstate
{	
	private var _level:Level;
	public function new(level:Level){
		super();
		_level = level;
	}

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

		var text2 = new flixel.text.FlxText(0, 0, 0, "press [R] to restart or [Q] to exit", 32);
		text2.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,5);
		text2.screenCenter();
		text2.y += 40;
		add(text2);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		if (FlxG.keys.anyJustPressed([Q]))
			FlxG.switchState(new MenuState());
		if (FlxG.keys.anyJustPressed([R]))
			FlxG.switchState(new GameState(_level));
	}	
}