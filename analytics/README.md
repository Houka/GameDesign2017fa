Analytics README  
================  
Wiki for getting data from the GDIAC server, then processing it with d3.  
  
Fetching JSON:
--------------
Run fetch_data.json: `node fetch_data.js <version> <offset>`  
You'll need to manually check that count >= player_quest entries in order to get the entire dataset. Go to the server site and increase the offset until you there's no more data sets: `http://gdiac.cs.cornell.edu/cs4154/fall2017/get_data.php?game_id=771&version_id=4&offset=<PLAY WITH THIS VALUE>`  
fetch_data.json will return the json data in `data.v<version>.json`  
  
Event-driven Logging:  
---------------------  
mouse press pos (x,y,time) = 1  
mouse release pos (x,y,time) = 2  
health change (hp, time) = 3  
wave start(currency, wave num, towers destroyed, time) = 4  
tower build(position (x,y), materials, time) = 5  
game over (wave num, level num) = 6  

Structure:
----------
3 js scripts:  
*   fetch_data.js
*   parse player quests.js  
        1.  bucketize players by id.  
        2.  look into the get_csv.php  
*   parse player actions.js
*   index.html -> d3