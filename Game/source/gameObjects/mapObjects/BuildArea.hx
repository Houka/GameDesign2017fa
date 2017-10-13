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
import gameObjects.materials.GunBase;
import AssetPaths;
import RenderBuffer;
import gameObjects.mapObjects.HUD; 
import flixel.addons.text.FlxTypeText;

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
    private var matValuesList:List<Int>; 
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
        matValuesList = new List<Int>();
        lastTowerPoint = new FlxPoint(x+width/2-30,y+height-180);
        isBuilding = false;

        // background of shop
        var bg = new GameObject(X-70,Y,AssetPaths.store__png,298,600);
        bg.y+=10;
        add(bg);

        createTestBuildArea();
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
    private function createTestBuildArea():Void
    {
        // buttons
        var ammoX = x+10;
        var ammoY = y+this.height-100;
        var buttons = [
            {name:"Gun 1 \n\n 1", callback:function() addMaterial(GameObjectFactory.createGunBase(lastTowerPoint.x,lastTowerPoint.y,GunType.Horizontal), 1)},
            {name:"Gun 2 \n\n 1", callback:function() addMaterial(GameObjectFactory.createGunBase(lastTowerPoint.x,lastTowerPoint.y,GunType.Vertical), 1)},
            {name:"Gun 3 \n\n 2", callback:function() addMaterial(GameObjectFactory.createGunBase(lastTowerPoint.x,lastTowerPoint.y,GunType.Diagonal), 2)},

            {name:"Snow \n\n 1", callback:function() addMaterial(GameObjectFactory.createFoundation(lastTowerPoint.x,lastTowerPoint.y), 1)},
            {name:"Ice \n\n 2", callback:function() addMaterial(GameObjectFactory.createFoundation(lastTowerPoint.x,lastTowerPoint.y), 2)},
            {name:"Metal \n\n 3", callback:function() addMaterial(GameObjectFactory.createFoundation(lastTowerPoint.x,lastTowerPoint.y), 3)},

            {name:"Ammo 1 \n\n 1", callback:function() addAmmo(GameObjectFactory.createAmmunition(ammoX,ammoY))},
            {name:"Ammo 2 \n\n 2", callback:function() addAmmo(GameObjectFactory.createAmmunition(ammoX,ammoY))},
            {name:"Ammo 3 \n\n 3", callback:function() addAmmo(GameObjectFactory.createAmmunition(ammoX,ammoY))}
        ];
        var gap = 10;
        var paddingX = 0;
        var paddingY = 120;
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

        var btn3: FlxButton = new FlxButton(x+this.width/2-70, y+this.height/2-50, "Remove", removeMaterial);
        add(btn3);
        var btn4: FlxButton = new FlxButton(x+this.width/2-70, y+this.height/2, "Remove Ammo", function() remove(ammo));
        add(btn4);
        var btn5: FlxButton = new FlxButton(x+this.width/2-70, y+this.height/2+50, "Build", function() isBuilding=true);
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

    private function addMaterial(obj:TowerBlock, amt: Int):Void{
        if (HUD.CURRENCY_AMOUNT > 0) {
            materialsList.push(obj);
            matValuesList.push(amt);
            obj.x -= obj.origin.x;
            lastTowerPoint.y -= obj.height-5;
            add(obj);

            HUD.CURRENCY_AMOUNT -= amt;
        }
    }


    private function popMaterial():TowerBlock{
        var obj = materialsList.pop();
        if (obj != null){
            lastTowerPoint.y += obj.height-5;
            remove(obj);
            // HUD.CURRENCY_AMOUNT += matValuesList.pop(); 
        }
        return obj;
    }

    private function removeMaterial():TowerBlock { 
        var obj = materialsList.pop();
        if (obj != null){
            lastTowerPoint.y += obj.height-5;
            remove(obj);
            HUD.CURRENCY_AMOUNT += matValuesList.pop(); 
        }
        return obj;
    }

    private function removeCurrency() { 
        for (i in matValuesList) {
            HUD.CURRENCY_AMOUNT -= i; 
        }
        isBuilding = true; 
    }
}