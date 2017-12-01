package gameStates;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.text.FlxText;
import flixel.system.FlxSound;

import LevelData;
import utils.Util;
import utils.Sounds;

class LevelSelectState extends FlxState
{
    private static inline var GRID_OFFSET_X:Float = Util.TILE_SIZE*2 - 8;
    private static inline var GRID_OFFSET_Y:Float = Util.TILE_SIZE*4 - 24;
    private static inline var GRID_WIDTH:Int = Util.TILE_SIZE*2;
    private static inline var GRID_HEIGHT:Int = Util.TILE_SIZE*2;
    private static inline var SQUARES_PER_ROW:Int = 6;
    private static inline var FONT_SIZE:Int = 16;
    private static inline var FONT_OFFSET_X:Int = -6;
    private static inline var FONT_OFFSET_Y:Int = 20;
    private var buttons:FlxTypedGroup<FlxSprite>;
    private var bg:FlxTilemap;
    
    /**
     * Build the level select screen.
     */
    override public function create():Void
    {
        buttons = new FlxTypedGroup<FlxSprite>();
        bg = new FlxTilemap();

        // Level Select BG
        var mapArray = Util.loadCSV("assets/maps/levelSelect.csv");
        bg.loadMapFrom2DArray(mapArray, "assets/tiles/auto_tilemap_menu.png", Util.TILE_SIZE,Util.TILE_SIZE, AUTO);

        // background to hide menuscreen
        var background = new FlxSprite(0,0);
        background.makeGraphic(FlxG.width,FlxG.height, 0xFF508AAD);
        background.alpha = 1;

        // "Select Level" Text
        var title = new FlxText(0,0, 0, "Select Level", 70);
        title.setFormat("assets/fonts/almonte.ttf", 72, FlxColor.fromInt(0xFF508AAD));
        title.screenCenter();
        title.y -= Std.int(FlxG.height/2) - 100;

        // Back button
        var backButton = new FlxButton(GRID_OFFSET_X-32-16,GRID_OFFSET_Y-128-32,"",mainMenuCallback);
        backButton.loadGraphic(AssetPaths.backButton__png, true, 50, 50);
        buttons.add(backButton);

        // Level select buttons
        var levelButton:FlxButton;
        var levels = [0,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16];
        for (i in 0...levels.length){
            var x = (i%SQUARES_PER_ROW)*GRID_WIDTH+GRID_OFFSET_X;
            var y = Std.int(i/SQUARES_PER_ROW)*GRID_HEIGHT+GRID_OFFSET_Y;
            if(levels[i]<=LevelData.maxLevelReached){
                levelButton = new FlxButton(x, y, (i+1)+"", levelCallback.bind(levels[i]));
                levelButton.loadGraphic(AssetPaths.levelButton__png, true, 55, 64);
                levelButton.label.size = FONT_SIZE;
                levelButton.label.offset.x -= FONT_OFFSET_X;
                levelButton.label.offset.y -= FONT_OFFSET_Y;
                buttons.add(levelButton);
            }
            else{
                var lockedLevel = new FlxSprite(x,y,AssetPaths.levelLocked__png);
                buttons.add(lockedLevel);
            }
        }
        
        // Add everything to the state
        add(background);
        add(bg);
        add(title);
        add(buttons);

        // shift everything down and add a tween to have it come back up
        var secs = 0.5;
        FlxTween.tween(background, { y: background.y }, secs, { ease: FlxEase.expoOut});
        FlxTween.tween(bg, { y: bg.y }, secs, { ease: FlxEase.expoOut});
        FlxTween.tween(title, { y: title.y }, secs, { ease: FlxEase.expoOut});
        for (b in buttons){
            FlxTween.tween(b, { y: b.y }, secs, { ease: FlxEase.expoOut});
        }
        background.y+=FlxG.height;
        bg.y+=FlxG.height;
        title.y+=FlxG.height;
        for (b in buttons){
            b.y+=FlxG.height;
        }

        super.create();
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (FlxG.keys.anyJustPressed([Q])) {
            mainMenuCallback();
        }
    }
    
    /**
     * Switch to GameState on selected level.
     */
    private function levelCallback(level:Int):Void
    {
        Sounds.play("select");
        LevelData.currentLevel = level;
        FlxG.switchState(new GameState());
    }

    /**
     * Go back to Main Menu; can also press [Q].
     */
    private function mainMenuCallback():Void{
        Sounds.play("select");
        FlxG.switchState(new MenuState());
    }
}