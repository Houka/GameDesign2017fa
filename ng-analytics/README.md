Analytics README  
================  
Wiki for getting data from the GDIAC server, then processing it with d3.  
  
Viewing Analytics
-----------------
Analytics can be viewed at http://liyiming-serif.github.io/  
Find the most up to date source code at https://github.com/liyiming-serif/liyiming-serif.github.io/

Fetching JSON:
--------------
Run fetch_data.json: `node fetch_data.js <version> <offset>`  
You'll need to manually check that count >= player_quest entries in order to get the entire dataset. Go to the server site and increase the offset until you there's no more data sets: `http://gdiac.cs.cornell.edu/cs4154/fall2017/get_data.php?game_id=771&version_id=<ver num>&offset=<ADJUST THIS VALUE>`  
fetch_data.json will return the json data in `data.json`  
  
Event-driven Logging:  
---------------------  
mouse press pos (Time, Level, X, Y) = 1  
mouse release pos (Time, Level, X, Y) = 2  
health change (Time, Level, HP) = 3  
wave start(Time, Level, Wave, Towers Killed) = 4  
tower build(Time, Level, X, Y, Materials, Height) = 5  
game over (Time, Wave Num, Level) = 6  
level win (Time, Level) = 7

Structure:
----------
3 js scripts:  
*   fetch_data.js
*   parse player quests.js  
        1.  bucketize players by id.  
        2.  look into the get_csv.php  
*   parse player actions.js
*   index.html -> d3

AB Testing:  
-----------  
A: Game doesn't pause during tower creation  
B: Game pauses when building tower  
  
TODO:  
-----  
*   label axes for heatmaps  
  
Updates:  
--------  
"Time" in player actions now tracks the number of seconds the event was recorded from the time the player started up the level.  
  
New action event: 7. Jots down when a player beats a level and which one.  
  
The "Tower Build" event tracks height of tower placed under the property "Height" (previously under the "Materials" property). The "Materials" property is now an array of materials:Int.    
