package gameObjects;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import AssetPaths;
import Constants;
import gameObjects.TowerBlock; 

class Tower extends FlxSprite
{
	private static inline var COST_INCREASE:Float = 1.5;
	private static inline var BASE_PRICE:Int = 10;

	public var range:Int = 100;
	public var fireRate:Float = 1;
	public var damage:Int = 1;
	
	public var rangeLevel:Int = 1;
	public var fireRateLevel:Int = 1;
	public var damageLevel:Int = 1;
	
	public var rangePrice:Int = BASE_PRICE;
	public var fireRatePrice:Int = BASE_PRICE;
	public var damagePrice:Int = BASE_PRICE;
	
	private var _shootInterval:Int = 2;
	private var _shootCounter:Int = 0;
	private var _initialCost:Int = 0;
	private var _indicator:FlxSprite;

	public var children:Array<TowerBlock>; 

	
	/**
	 * Create a new tower at X and Y with default range, fire rate, and damage; create this tower's indicator.
	 */
	public function new(X:Float, Y:Float, Cost:Int, materials:Array<TowerBlock>)
	{
		super(X, Y);
		loadGraphic(AssetPaths.tower__png);

		health = 0; 
		
		_initialCost = Cost;
		this.children = new Array<TowerBlock>();
		for (m in materials) {
			addTowerBlock(m);
		}
		addTowerHealth(); 

		_indicator = new FlxSprite(getMidpoint().x, getMidpoint().y);
		_indicator.loadGraphic(AssetPaths.snowball__png, false, 16, 16);
		_indicator.x -= _indicator.origin.x;
		_indicator.y -= _indicator.origin.y;
		Constants.PS.collisionController.towerIndicators.add(_indicator);
	}
	
	/**
	 * The tower's update function just checks if there's an enemy nearby; if so, the indicator "charges"
	 * by slowly increasing its alpha; once the shootCounter has reached the required level, a bullet is
	 * shot.
	 */
	override public function update(elapsed:Float):Void
	{	
		if (getNearestEnemy() == null)
		{
			_indicator.visible = false;
		}
		else
		{
			_indicator.visible = true;
			_indicator.alpha = _shootCounter / (_shootInterval * FlxG.updateFramerate);
			
			_shootCounter += Std.int(FlxG.timeScale);
			
			if (_shootCounter > (_shootInterval * FlxG.updateFramerate) * fireRate)
			{
				shoot();
			}
		}
		
		super.update(elapsed);
	}

	
	/**
	 * Inflict horrible pain on this tower
	 * 
	 * @param	Damage	The damage to deal to this enemy.
	 */
	override public function hurt(Damage:Float):Void
	{
		health -= Damage;
		alpha -= Damage;
		
		if (health <= 0){
			Constants.PS.removeTower(this);
			kill();
		}
	}
	
	/**
	 * Used to determine value of a tower when selling it. Equivalent to half its next upgrade costs plus half its base cost.
	 */
	public var value(get, null):Int;
	
	private function get_value():Int
	{
		var val:Float = _initialCost;
		
		val += rangePrice - BASE_PRICE;
		val += fireRatePrice - BASE_PRICE;
		val += damagePrice - BASE_PRICE;
		val = Math.round(val / 2);
		
		return Std.int(val);
	}
	
	/**
	 * Shoots a bullet! Called when shootCounter reaches the required limit.
	 */
	private function shoot():Void
	{
		var target:Enemy = getNearestEnemy();
		if (target == null)
			return;
		
		var bullet = Constants.PS.collisionController.bullets.recycle(Bullet.new);
		var midpoint = getMidpoint();
		bullet.init(midpoint.x - bullet.getMidpoint().x, midpoint.y- bullet.getMidpoint().y, target, damage);
		midpoint.put();
		
		Constants.play("shoot");
		
		_shootCounter = 0;
	}
	
	/**
	 * Goes through the entire enemy group and returns the first non-null enemy within range of this tower.
	 * 
	 * @return	The first enemy that is not null, in range, and alive. Returns null if none found.
	 */
	private function getNearestEnemy():Enemy
	{
		var firstEnemy:Enemy = null;
		var enemies:FlxTypedGroup<Enemy> = Constants.PS.collisionController.enemies;
		
		for (enemy in enemies)
		{
			if (enemy != null && enemy.alive)
			{
				var distance:Float = getPosition().distanceTo(enemy.getPosition());
				if (distance <= range)
				{
					firstEnemy = enemy;
					break;
				}
			}
		}
		
		return firstEnemy;
	}
	
	/**
	 * Upgrading range increases the radius within which it will consider enemies valid targets by 10.
	 * Also updates the rangeLevel and rangePrice (1.5 x LEVEL) values for display and player money impact.
	 */
	public function upgradeRange():Void
	{
		range += 10;
		rangeLevel++;
		rangePrice = Std.int(rangePrice * COST_INCREASE);
	}

	/**
	 * Upgrading damage increases the damage value passed to bullets, and later enemies, by 1.
	 * Also updates the damageLevel and damagePrice (1.5 x LEVEL) values for display and player money impact.
	 */
	public function upgradeDamage():Void
	{
		damage++;
		damageLevel++;
		damagePrice = Std.int(damagePrice * COST_INCREASE);
	}
	
	/**
	 * Upgrading fire rate decreases time between shots by 10%.
	 * Also updates the fireRateLevel and fireRatePrice (1.5 x LEVEL) values for display and player money impact.
	 */
	public function upgradeFirerate():Void
	{
		fireRate *= 0.9;
		fireRateLevel++;
		fireRatePrice = Std.int(fireRatePrice * COST_INCREASE);
	}

	public function addTowerBlock(obj:TowerBlock):Bool{
        if (!obj.inTower && children.length < Constants.MAX_HEIGHT){
            obj.inTower = true;
            children.push(obj);
            return true;
        }
        return false;
    }

    private function addTowerHealth(): Void { 
    	for (i in this.children) {
    		if (Std.is(i, Foundation)) {
    			health += cast(i, Foundation).healthPoints; 
    		}
    	}
    }
}
