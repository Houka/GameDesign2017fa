package test;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.text.FlxText;

import test.GameState.Level;
import test.GameState.LevelData;
import test.GameState.Util;
import gameStates.MenuState;

class LevelSelectState extends FlxState
{
    private static inline var GRID_OFFSET_X:Float = Util.TILE_SIZE*3 - 8;
    private static inline var GRID_OFFSET_Y:Float = Util.TILE_SIZE*4 - 24;
    private static inline var GRID_WIDTH:Int = Util.TILE_SIZE*3;
    private static inline var GRID_HEIGHT:Int = Util.TILE_SIZE*2;
    private static inline var SQUARES_PER_ROW:Int = 4;
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
        FlxG.cameras.bgColor = FlxColor.fromInt(0xff85bbff);
        var mapArray = Util.loadCSV("assets/maps/levelSelect.csv");
        bg.loadMapFrom2DArray(mapArray, "assets/tiles/auto_tilemap.png", Util.TILE_SIZE,Util.TILE_SIZE, AUTO);

        // "Select Level" Text
        var title = new FlxText(FlxG.width/2-100, Util.TILE_SIZE, 0, "Select Level", 28);
        title.setBorderStyle(OUTLINE_FAST, FlxColor.BLACK,1);
        title.alignment = CENTER;

        // Back button
        var backButton = new FlxButton(GRID_OFFSET_X-128,GRID_OFFSET_Y-32,"",mainMenuCallback);
        backButton.loadGraphic(AssetPaths.backButton__png, true, 50, 50);
        buttons.add(backButton);

        // Level select buttons
        var levelButton:FlxButton;
        var levels = [0,2,3,4,5,6,7,8,9,10,11,12];
        for (i in 0...levels.length){
            var x = (i%SQUARES_PER_ROW)*GRID_WIDTH+GRID_OFFSET_X;
            var y = Std.int(i/SQUARES_PER_ROW)*GRID_HEIGHT+GRID_OFFSET_Y;
            if(i<=LevelData.maxLevelReached){
                levelButton = new FlxButton(x, y, (i+1)+"", levelCallback.bind(i));
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
        add(bg);
        add(title);
        add(buttons);

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
        LevelData.currentLevel = level;
        FlxG.switchState(new GameState());
    }

    /**
     * Go back to Main Menu; can also press [Q].
     */
    private function mainMenuCallback():Void{
        FlxG.switchState(new MenuState());
    }
}