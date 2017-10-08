package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.ui.FlxButton; 
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.group.FlxGroup;
import gameObjects.materials.Material;

/**
 * @author Chang Lu
 */

class BuildArea extends FlxGroup
{
    private var x:Float;
    private var y:Float;
    private var width:Float;
    private var height:Float;
    private var materialsList:Array<Material>;
    private var lastTowerPoint:FlxPoint;

    /** Initialize each component of the tower based on materialsList
     */
    public function new(X:Float, Y:Float, width:Float, height:Float, ?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(20);
        setPosition(X,Y);
        this.width = width;
        this.height - height;
        materialsList = new Array<Material>();
        lastTowerPoint = new FlxPoint(x+width/2,y+height/2+200);

        // background of shop
        var bg = new GameObject(X,Y,graphicAsset,graphicsWidth,graphicsHeight);
        bg.y+=10;
        bg.makeGraphic(cast(width),cast(height), FlxColor.WHITE, true);
        add(bg);

        createTestBuidArea();
    }

    public function setPosition(x:Float,y:Float){
        this.x = x;
        this.y = y;
    }

    // TODO: remove test function
    private function createTestBuidArea():Void
    {
        // buttons
        var btn1: FlxButton = new FlxButton(x+20, y+10, "Buy Normal Gun Base", 
            function() addMaterial(GameObjectFactory.createGunBase(lastTowerPoint.x,lastTowerPoint.y)));
        add(btn1);
        var btn2: FlxButton = new FlxButton(x+20, y+50, "Buy Wood Wall", 
            function() addMaterial(GameObjectFactory.createFoundation(lastTowerPoint.x,lastTowerPoint.y)));
        add(btn2);
        var btn3: FlxButton = new FlxButton(x+20, y+90, "Buy Ammo", 
            function() addMaterial(GameObjectFactory.createAmmunition(lastTowerPoint.x,lastTowerPoint.y)));
        add(btn3);
        var btn3: FlxButton = new FlxButton(x+20, y+130, "Remove", popMaterial);
        add(btn3);
    }

    private function addMaterial(obj:Material):Void{
        materialsList.push(obj);
        lastTowerPoint.y -= obj.height-5;
        add(obj);
    }

    private function popMaterial():Void{
        var obj = materialsList.pop();
        if (obj != null){
            lastTowerPoint.y += obj.height-5;
            remove(obj);
        }
    }
}