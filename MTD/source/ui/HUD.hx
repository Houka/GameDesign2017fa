package ui;

import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import Constants;
import AssetPaths;

class HUD extends FlxGroup{
	// static vars
	public static var health(default, set):Int;
	public static var money(default, set):Int;
	public static var hud:HUD;

	private static var loseGameCallback:Void->Void;
	private static var winGameCallback:Void->Void;

	// hud vars
	public var healthSprites:FlxGroup;
	public var moneyText:FlxText;
	public var enemyText:FlxText;
	public var waveText:FlxText;

	// HUD singleton
	public function new(health:Int, money:Int){
		super();
		moneyText = new FlxText(10, 30, FlxG.width - 4, "$: " + money,Constants.HUD_TEXT_SIZE);
		
		waveText = new FlxText(10, 50, FlxG.width, "Wave",Constants.HUD_TEXT_SIZE);
		waveText.visible = false;
		
		enemyText = new FlxText(10, 70, FlxG.width, "Wave",Constants.HUD_TEXT_SIZE);
		enemyText.visible = false;
		
		add(moneyText);
		add(enemyText);
		add(waveText);

		healthSprites = new FlxGroup();
		var xOffset = 10;
		var yOffset = 10;
		var gap = 20;
		for (h in 0...health)
		{
			var heart = new FlxSprite(xOffset + gap * h, yOffset, AssetPaths.heart__png);
			healthSprites.add(heart);
		}

		add(healthSprites);
	}

	override public function update(e:Float):Void{
		// These elements expand when increased; this reduces their size back to normal
		
		if (moneyText.size > Constants.HUD_TEXT_SIZE)
			moneyText.size--;
		
		if (enemyText.size > Constants.HUD_TEXT_SIZE)
			enemyText.size--;
		
		if (waveText.size > Constants.HUD_TEXT_SIZE)
			waveText.size--;		
	}

	// Static functions
	public static function init(level:Level, loseGameCallback:Void->Void, winGameCallback:Void->Void){
		HUD.hud = new HUD(level.health, level.money);
		HUD.health = level.health;
		HUD.money = level.money;
		HUD.winGameCallback = winGameCallback;
		HUD.loseGameCallback = loseGameCallback;
	}

	private static function set_health(Health:Int):Int{
		if (HUD.health >= 0 && HUD.health > Health)
			HUD.hud.healthSprites.members[Health].kill();

		HUD.health = Health;
		
		if (HUD.health == 0)
			HUD.loseGameCallback();

		return HUD.health;
	}

	private static function set_money(Money:Int):Int{
		HUD.money = Money;
		HUD.hud.moneyText.text = "$: " + HUD.money;
		HUD.hud.moneyText.size = Constants.HUD_TEXT_SIZE;

		return HUD.money;
	}
}