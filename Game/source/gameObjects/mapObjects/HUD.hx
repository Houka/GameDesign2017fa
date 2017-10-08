package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.text.FlxText;
import flixel.group.FlxGroup;
import gameObjects.GameObject;
import gameStates.*;

/**
 * @author Chang Lu
 * 
 * Static class to be used by all fields
 */
typedef GraphicObj = { 
    var asset:FlxGraphicAsset;
    var width:Int;
    var height:Int;
}

class HUD extends FlxTypedGroup<FlxObject>
{
    public static var CURRENCY_AMOUNT:Int=0;
    public static var HEALTH:Int=0;
    public static var HEALTH_GRAPHIC:GraphicObj = {asset: null, width: 0, height: 0};
    public static var CURRENCY_GRAPHIC:GraphicObj = {asset: null, width: 0, height: 0};
    public static var hud:HUD = null;

    public var healthText:FlxText;
    public var currencyText:FlxText;

    public function new(MaxSize:Int=0):Void{
        super(MaxSize);

        healthText = new flixel.text.FlxText(10, 10, 0, "HP " + HUD.HEALTH, 12);
        currencyText = new flixel.text.FlxText(10, 30, 0, "$ " + HUD.CURRENCY_AMOUNT, 12);
        add(healthText);
        add(currencyText);
    }

    override function update(e:Float):Void{
        super.update(e);
        healthText.text = "HP "+ HUD.HEALTH;
        currencyText.text = "$ " + HUD.CURRENCY_AMOUNT;

        // game over things go here
        if (HUD.HEALTH <= 0){
            FlxG.switchState(new MenuState());
        }
    }

    public static function reset(health:Int, currencyAmount:Int)
    {
        HUD.HEALTH = health;
        HUD.CURRENCY_AMOUNT = currencyAmount;
        if (HUD.hud != null){
            HUD.hud.forEach(function (t) t.destroy());
            HUD.hud.clear();
            HUD.hud.destroy();
        }
        HUD.hud = new HUD(10);
    }

    public static function loadHealthGraphic(graphicAsset:FlxGraphicAsset, graphicsWidth:Int, graphicsHeight:Int):Void{
        HEALTH_GRAPHIC = {asset: graphicAsset, width: graphicsWidth, height: graphicsHeight};
    }

    public static function loadCurrencyGraphic(graphicAsset:FlxGraphicAsset, graphicsWidth:Int, graphicsHeight:Int):Void{
        CURRENCY_GRAPHIC = {asset: graphicAsset, width: graphicsWidth, height: graphicsHeight};
    }

    public static function addHUD(state:FlxState):Void{
        state.add(HUD.hud);
    }
}
