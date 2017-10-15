package ui;

import flash.display.Sprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxG;
import gameObjects.Tower;
import utils.Button;
import Constants;

enum MenuType
{
	General;
	Upgrade;
	Sell;
	ConfirmSell;
}

class InGameMenu extends FlxGroup{
	// Static vars accessible by anyone
	public static var towerSelected:Tower;

	/**
	 * Helper Sprite object to draw tower's range graphic
	 */
	private static var RANGE_SPRITE:Sprite = null;

	// Menu Groups
	public var defaultMenu:FlxGroup;
	public var upgradeMenu:FlxGroup;
	public var sellMenu:FlxGroup;
	public var sellConfirmMenu:FlxGroup;

	// Game Object variables
	public var towerPrice:Int = 8;
	private var _speed:Int = 1;

	// Bools
	public var buildingMode(default,set):Bool = false;

	// Text
	private var _tutText:FlxText;
	private var _areYouSure:FlxText;

	// Buttons
	public var _nextWaveButton:Button; 	// TODO: somehow make this private cleanly
	public var _towerButton:Button;		// TODO: somehow make this private cleanly
	private var _speedButton:Button;
	private var _sellButton:Button;

	private var _damageButton:Button;
	private var _firerateButton:Button;
	private var _rangeButton:Button;

	// Sprites
	public var _towerRange:FlxSprite;	// TODO: somehow make this private cleanly
	private var _buildHelper:FlxSprite;

	public function new(nextWaveCallback:Bool->Void, sellConfirmCallback:Bool->Void){
		super();

		// menus
		defaultMenu = new FlxGroup();
		upgradeMenu = new FlxGroup();
		sellMenu = new FlxGroup();
		sellConfirmMenu = new FlxGroup();

		// buttons
		var height:Int = FlxG.height - 18;
		_towerButton = new Button(2, height, "Buy [T]ower ($" + towerPrice + ")", buildTowerCallback.bind(false), 120);
		_nextWaveButton = new Button(100, height, "[N]ext Wave", nextWaveCallback.bind(false), 143);
		_speedButton = new Button(FlxG.width - 20, height, "x1", speedButtonCallback.bind(false), 21);
		_sellButton = new Button(220, height, "[S]ell Mode", sellButtonCallback.bind(true));
		_sellButton.visible = false;
		_damageButton = new Button(100, height, "Damage (##): $##", upgradeDamageCallback);
		_firerateButton = new Button(200, height, "Firerate (##): $##", upgradeFirerateCallback);
		_rangeButton = new Button(14, height, "Range (##): $##", upgradeRangeCallback);
		_areYouSure = new FlxText(20, height + 3, 200, "Tower value $###, really sell?");
		_areYouSure.color = FlxColor.BLACK;

		// text
		_tutText = new FlxText(0, height - 10, FlxG.width, "Click on a Tower to Upgrade it!");
		_tutText.alignment = CENTER;
		_tutText.visible = false;

		var sellMessage = new FlxText(0, height + 3, FlxG.width, "Click on a tower to sell it");
		sellMessage.color = FlxColor.BLACK;
		sellMessage.alignment = CENTER;

		// add to menus
		defaultMenu.add(_towerButton);
		defaultMenu.add(_nextWaveButton);
		defaultMenu.add(_speedButton);
		defaultMenu.add(_sellButton);
		defaultMenu.add(_tutText);

		upgradeMenu.add(new Button(2, height, "<", toggleMenus.bind(General), 10));
		upgradeMenu.add(_damageButton);
		upgradeMenu.add(_firerateButton);
		upgradeMenu.add(_rangeButton);
		upgradeMenu.visible = false;

		sellMenu.add(sellMessage);
		sellMenu.add(new Button(2, height, "<", sellMenuCancel.bind(false), 10));
		sellMenu.visible = false;

		sellConfirmMenu.add(new Button(2, height, "<", sellMenuCancel.bind(false), 10));
		sellConfirmMenu.add(_areYouSure);
		sellConfirmMenu.add(new Button(220, height, "[Y]es", sellConfirmCallback.bind(true)));
		sellConfirmMenu.add(new Button(280, height, "[N]o", sellConfirmCallback.bind(false)));
		sellConfirmMenu.visible = false;

		// Helper Sprites
		_buildHelper = new FlxSprite(0, 0, AssetPaths.tower_placement__png);
		_buildHelper.visible = false;

		_towerRange = new FlxSprite(0, 0);
		_towerRange.visible = false;

		// BG
		var bg = new FlxSprite(0, FlxG.height - 16);
		bg.makeGraphic(FlxG.width, 16, FlxColor.WHITE);

		// add to overall menu
		add(bg);
		add(_towerRange);
		add(_buildHelper);
		add(defaultMenu);
		add(upgradeMenu);
		add(sellMenu);
		add(sellConfirmMenu);
	}

	override public function kill():Void{
		upgradeMenu.kill();
		_towerRange.kill();
		super.kill();
	}

	override public function update(e:Float):Void{
		super.update(e);

		// Key press shortcuts for buttons

		if (FlxG.keys.justReleased.T) buildTowerCallback(true); 
		if (FlxG.keys.justReleased.SPACE) speedButtonCallback(true); 
		if (FlxG.keys.justReleased.S) sellButtonCallback(true);
		if (FlxG.keys.justReleased.ESCAPE) toggleMenus(General); 
		if (FlxG.keys.justReleased.ONE) upgradeRangeCallback(); 
		if (FlxG.keys.justReleased.TWO) upgradeDamageCallback(); 
		if (FlxG.keys.justReleased.THREE) upgradeFirerateCallback(); 

		// If needed, updates the grid highlight square buildHelper and the range indicator
		
		if (buildingMode)
		{
			_buildHelper.x = FlxG.mouse.x - (FlxG.mouse.x % Constants.TILE_SIZE);
			_buildHelper.y = FlxG.mouse.y - (FlxG.mouse.y % Constants.TILE_SIZE);
			updateRangeSprite(_buildHelper.getMidpoint(), 100);
		}
	}
	
	/**
	 * Controls the displayed menu.
	 * 
	 * @param	Menu	The desired menu; one of the enum constructors above this class.
	 */
	public function toggleMenus(Menu:MenuType):Void
	{
		sellConfirmMenu.visible = false;
		sellMenu.visible = false;
		upgradeMenu.visible = false;
		defaultMenu.visible = false;
		_towerRange.visible = false;
		
		switch (Menu)
		{
			case General:
				defaultMenu.visible = true;
				InGameMenu.towerSelected = null;
				buildingMode = false;
				_buildHelper.visible = false;
			case Upgrade:
				updateUpgradeLabels();
				upgradeMenu.visible = true;
			case Sell:
				sellMenu.visible = true;
			case ConfirmSell:
				sellConfirmCheck();
				sellConfirmMenu.visible = true;
		}
		
		Constants.playSelectSound();
	}

	/**
	 * Called after first tower was built. Has Tutorial purposes
	 */
	public function builtFirstTower(){
		// After the first tower is bought, sell mode becomes available.
		if (_sellButton.visible == false)
			_sellButton.visible = true;

		// If this is the first tower the player has built, they get the tutorial text.
		// This is made invisible after they've bought an upgrade.
		if (_tutText.visible == false)
			_tutText.visible = true;
	}

	/**
	 * Called after last tower was sold.
	 */
	public function soldLastTower(){
		_sellButton.visible = false;
		
		if (_tutText.visible)
			_tutText.visible = false;
	}

	/**
	 * Checks to see if the player really wants to sell the tower
	 */
	private function sellConfirmCheck():Void
	{
		_areYouSure.text = "Tower value $" +  InGameMenu.towerSelected.value + ", really sell?";
		
		updateRangeSprite( InGameMenu.towerSelected.getMidpoint(),  InGameMenu.towerSelected.range);
	}
	
	/**
	 * Called when the user attempts to update range. If they have enough money, the upgradeRange() function
	 * for this tower is called, and the money is decreased.
	 */
	private function upgradeRangeCallback():Void
	{
		if (!upgradeMenu.visible)
			return;
		
		if (HUD.money >= InGameMenu.towerSelected.rangePrice)
		{
			HUD.money -= InGameMenu.towerSelected.rangePrice;
			InGameMenu.towerSelected.upgradeRange();
			upgradeHelper();
		}
	}
	
	/**
	 * Called when the user attempts to update damage. If they have enough money, the upgradeDamage() function
	 * for this tower is called, and the money is decreased.
	 */
	private function upgradeDamageCallback():Void
	{
		if (!upgradeMenu.visible)
			return;
		
		if (HUD.money >= InGameMenu.towerSelected.damagePrice)
		{
			HUD.money -= InGameMenu.towerSelected.damagePrice;
			InGameMenu.towerSelected.upgradeDamage();
			upgradeHelper();
		}
	}
	
	/**
	 * Called when the user attempts to update fire rate. If they have enough money, the upgradeFirerate() function
	 * for this tower is called, and the money is decreased.
	 */
	private function upgradeFirerateCallback():Void
	{
		if (!upgradeMenu.visible)
			return;
		
		if (HUD.money >= InGameMenu.towerSelected.fireRatePrice)
		{
			HUD.money -= InGameMenu.towerSelected.fireRatePrice;
			InGameMenu.towerSelected.upgradeFirerate();
			upgradeHelper();
		}
	}
	
	/**
	 * Called after an upgrade. Updates button text, plays a sound, and sets the upgrade bought flag to true.
	 */
	private function upgradeHelper():Void
	{
		updateUpgradeLabels();
		Constants.playSelectSound();
		
		if (_tutText.visible)
			_tutText.visible = false;
	}
	
	/**
	 * Update button labels for upgrades, and makes sure the range indicator sprite is updated.
	 */
	private function updateUpgradeLabels():Void
	{
		_rangeButton.text = "Range (" + InGameMenu.towerSelected.rangeLevel + "): $" + InGameMenu.towerSelected.rangePrice; 
		_damageButton.text = "Damage (" + InGameMenu.towerSelected.damageLevel + "): $" + InGameMenu.towerSelected.damagePrice; 
		_firerateButton.text = "Firerate (" + InGameMenu.towerSelected.fireRateLevel + "): $" + InGameMenu.towerSelected.fireRatePrice; 
		
		updateRangeSprite(InGameMenu.towerSelected.getMidpoint(), InGameMenu.towerSelected.range);
	}
	/**
	 * A function that is called when the user enters build mode.
	 */
	private function buildTowerCallback(Skip:Bool = false):Void
	{
		if (towerPrice > HUD.money || towerSelected != null)
			return;
		
		buildingMode = !buildingMode;
		#if !mobile
		_towerRange.visible = !_towerRange.visible;
		_buildHelper.visible = buildingMode;
		#end
		
		Constants.playSelectSound();
	}
	
	/**
	 * A function that is called when the user changes game speed.
	 */
	private function speedButtonCallback(Skip:Bool = false):Void
	{
		if (!defaultMenu.visible && !Skip)
			return;
		
		if (_speed < 3)
			_speed += 1;
		else
			_speed = 1;
		
		FlxG.timeScale = _speed;
		_speedButton.text = "x" + _speed;
		
		Constants.playSelectSound();
	}
	
	/**
	 * A function that is called when the user wants to sell a tower.
	 */
	private function sellButtonCallback(Skip:Bool = false):Void
	{
		if (!defaultMenu.visible)
			return;
		
		toggleMenus(Sell);
		
		if (buildingMode)
		{
			buildingMode = false;
			_towerRange.visible = false;
		}
		
		Constants.playSelectSound();
	}

	private function sellMenuCancel(Skip:Bool = false):Void
	{
		toggleMenus(General);
	}
	
	/**
	 * Called either when building, or upgrading, a tower.
	 */
	private function updateRangeSprite(Center:FlxPoint, Range:Int):Void
	{
		_towerRange.setPosition(Center.x - Range, Center.y - Range);
		_towerRange.makeGraphic(Range * 2, Range * 2, FlxColor.TRANSPARENT);
		
		// Using and re-using a static sprite like this reduces garbage creation.
		
		RANGE_SPRITE = new Sprite();
		RANGE_SPRITE.graphics.beginFill(0xFFFFFF);
		RANGE_SPRITE.graphics.drawCircle(Range, Range, Range);
		RANGE_SPRITE.graphics.endFill();
		
		_towerRange.pixels.draw(RANGE_SPRITE);
		
		#if flash
		// _towerRange.blend = BlendMode.INVERT;
		#else
		_towerRange.alpha = 0.5;
		#end
		
		_towerRange.visible = true;
	}

	private function set_buildingMode(Value:Bool):Bool{
		if(Value)
			Constants.toggleCursors(Build);
		else
			Constants.toggleCursors(Normal);
		buildingMode = Value;
		return buildingMode;
	}
}