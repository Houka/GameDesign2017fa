package gameObjects.mapObjects;

import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColor;
import flixel.ui.FlxButton; 
import flixel.math.FlxPoint;
import flixel.FlxG;
import flixel.group.FlxGroup;
import gameObjects.materials.TowerBlock;
import gameObjects.materials.Ammunition;
import AssetPaths;
import RenderBuffer;

/**
 * @author Chang Lu
 */
typedef ButtonObject = {
    var name:String;
    var callback:Void->Void;
}

class BuildArea extends FlxGroup
{
    private var x:Float;
    private var y:Float;
    private var width:Float;
    private var height:Float;
    private var isBuilding:Bool;
    private var materialsList:List<TowerBlock>;
    private var ammo:Ammunition = null;
    private var lastTowerPoint:FlxPoint;

    /** Initialize each component of the tower based on materialsList
     */
    public function new(X:Float, Y:Float, width:Float, height:Float, ?graphicAsset:FlxGraphicAsset, ?graphicsWidth:Int, ?graphicsHeight:Int)
    {
        super(20);
        setPosition(X,Y);
        this.width = width;
        this.height = height;
        materialsList = new List<TowerBlock>();
        lastTowerPoint = new FlxPoint(x+width/2,y+height-100);
        isBuilding = false;

        // background of shop
        var bg = new GameObject(X,Y,graphicAsset,graphicsWidth,graphicsHeight);
        bg.y+=10;
        bg.makeGraphic(cast(width),cast(height), FlxColor.GRAY, true);
        add(bg);

        createTestBuidArea();
    }

    public function setPosition(x:Float,y:Float){
        this.x = x;
        this.y = y;
    }

    override public function update(e:Float){
        super.update(e);
        if (isBuilding && FlxG.mouse.justPressed){
            isBuilding = false;
            // copy the holding list
            var copy = new List<TowerBlock>();
            while(materialsList.length>0)
                copy.push(popMaterial());

            RenderBuffer.add(GameObjectFactory.createTower(FlxG.mouse.x,FlxG.mouse.y,copy,ammo));
        }
    }

    // TODO: remove test function
    private function createTestBuidArea():Void
    {
        // title
        var title = new FlxText(0, 0, 0, "STORE", 30);
        title.setPosition(x+width/2-title.fieldWidth/2, y+20);
        title.alignment = FlxTextAlign.CENTER;
        add(title);

        // buttons
        var ammoX = x+10;
        var ammoY = y+this.height-100;
        var buttons = [
            {name:"Gun 1", callback:function() addMaterial(GameObjectFactory.createGunBase(lastTowerPoint.x,lastTowerPoint.y))},
            {name:"Gun 2", callback:function() addMaterial(GameObjectFactory.createGunBase(lastTowerPoint.x,lastTowerPoint.y))},
            {name:"Gun 3", callback:function() addMaterial(GameObjectFactory.createGunBase(lastTowerPoint.x,lastTowerPoint.y))},

            {name:"Snow", callback:function() addMaterial(GameObjectFactory.createFoundation(lastTowerPoint.x,lastTowerPoint.y))},
            {name:"Ice", callback:function() addMaterial(GameObjectFactory.createFoundation(lastTowerPoint.x,lastTowerPoint.y))},
            {name:"Metal", callback:function() addMaterial(GameObjectFactory.createFoundation(lastTowerPoint.x,lastTowerPoint.y))},

            {name:"Ammo 1", callback:function() addAmmo(GameObjectFactory.createAmmunition(ammoX,ammoY))},
            {name:"Ammo 2", callback:function() addAmmo(GameObjectFactory.createAmmunition(ammoX,ammoY))},
            {name:"Ammo 3", callback:function() addAmmo(GameObjectFactory.createAmmunition(ammoX,ammoY))}
        ];
        var gap = 10;
        var paddingX = 30;
        var paddingY = 100;
        var width = 50;
        var height = 50;
        var row = 0;
        var col = -1;

        for (i in 0...buttons.length){
            col++;
            var btn: FlxButton = new FlxButton(x+col*(width+gap)+paddingX,y+row*(height+gap)+paddingY, buttons[i].name, buttons[i].callback);
            btn.loadGraphic(AssetPaths.button__png,true,width,height);
            add(btn);

            if ((i+1)%3 == 0) {
                row++;
                col = -1;
            }
        }

        var btn3: FlxButton = new FlxButton(x+this.width/2-40, y+this.height/2-50, "Remove", popMaterial);
        add(btn3);
        var btn4: FlxButton = new FlxButton(x+this.width/2-40, y+this.height/2, "Remove Ammo", function() remove(ammo));
        add(btn4);
        var btn5: FlxButton = new FlxButton(x+this.width/2-40, y+this.height/2+50, "Build", function() isBuilding=true);
        add(btn5);

    }

    private function addAmmo(obj:Ammunition){
        if (ammo == null)
            add(obj);
        else{
            removeAmmo();
            add(obj);
        }

        ammo = obj;
    }

    private function removeAmmo(){
        remove(ammo);
        ammo.destroy();
        ammo = null;
    }

    private function addMaterial(obj:TowerBlock):Void{
        materialsList.push(obj);
        obj.x -= obj.origin.x;
        lastTowerPoint.y -= obj.height-5;
        add(obj);
    }

    private function popMaterial():TowerBlock{
        var obj = materialsList.pop();
        if (obj != null){
            lastTowerPoint.y += obj.height-5;
            remove(obj);
        }
        return obj;
    }
}