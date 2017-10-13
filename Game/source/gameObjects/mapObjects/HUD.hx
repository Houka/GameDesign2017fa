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
import flixel.addons.text.FlxTypeText;

/**
 * @author Chang Lu
 * 
 * Singleton class to be used by all fields
 */
class HUD extends FlxTypedGroup<FlxObject>
{
    public static var CURRENCY_AMOUNT:Int=1;
    public static var HEALTH:Int=0;
    public static var hud:HUD = null;

    public var healthText:FlxText;
    public var currencyText:FlxText;

    public function new(MaxSize:Int=0):Void{
        super(MaxSize);

        healthText = new flixel.text.FlxText(30, 10, 0, "x" + HUD.HEALTH, 12);
        currencyText = new flixel.text.FlxText(30, 30, 0, "x" + HUD.CURRENCY_AMOUNT, 12);
        add(healthText);
        add(currencyText);
    }

    override function update(e:Float):Void{
        super.update(e);
        healthText.text = "x" + HUD.HEALTH;
        currencyText.text = "x" + HUD.CURRENCY_AMOUNT;
    }

    public static function reset(health:Int, currencyAmount:Int)
    {
        HUD.HEALTH = health;
        HUD.CURRENCY_AMOUNT = currencyAmount;
        if (HUD.hud != null){
            HUD.hud.clear();
            HUD.hud.destroy();
        }

        HUD.hud = new HUD(10);
    }

    public static function loadHealthGraphic(graphicAsset:FlxGraphicAsset, graphicsWidth:Int, graphicsHeight:Int):Void{
        if (HUD.hud != null)
            HUD.hud.add(new GameObject(10,10, graphicAsset, graphicsWidth, graphicsHeight));
    }

    public static function loadCurrencyGraphic(graphicAsset:FlxGraphicAsset, graphicsWidth:Int, graphicsHeight:Int):Void{
        if (HUD.hud != null){
            var coin = new GameObject(10,30, graphicAsset, graphicsWidth, graphicsHeight);
            coin.animation.add("spin", [0,1,2,3,2,1], 10, true);
            coin.animation.play("spin");
            HUD.hud.add(coin);
        }
    }

    public static function addHUD(state:FlxState):Void{
        state.add(HUD.hud);
    }

    public static function addTutorialText(tutText: String): Void { 
        var text: FlxTypeText = new FlxTypeText(0, 640, 1000, tutText, 15);
        HUD.hud.add(text);
        text.start();
    }
}
