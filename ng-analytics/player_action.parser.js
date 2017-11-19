function parseAct(data, actType){
    var help = "Parse player actions from data.json, and output a JSON of just those actions.\n"+
        "Input:\n\tdata:raw JSON data; actType:int 1-6\n"+
        "Actions:\n"+
        "\t1: Mouse Press\n"+
        "\t2: Mouse Release\n"+
        "\t3: HP Decrease\n"+
        "\t4: Wave Start\n"+
        "\t5: Tower Create\n"+
        "\t6: Game Over\n"+
        "\t7: Level Win\n";

    if(isNaN(actType)){
        throw help;
    }

    var regex = /[A-Za-z]*\s[A-Za-z]+\:/;
    var fields;
    switch(actType){
        case 1: //Mouse Press: Level:<> X:<> Y:<>/
            fields = ["Time","Level","X","Y"];
            break;
        case 2: //Mouse Release: Level:<> X:<> Y:<>
            fields = ["Time","Level","X","Y"];
            break;
        case 3: //HP Decrease: Level:<> HP:<>
            fields = ["Time","Level","HP"];
            break;
        case 4: //Wave Start: Level:<> Wave:<> Towers Killed:<>
            fields = ["Time","Level","Wave","Towers Killed"];
            break;
        case 5: //Tower Create: Level:<> x:<> y:<> Materials:<>
            fields = ["Time","Level","X","Y","Materials"];
            break;
        case 6: //Game Over: Wave num:<> Level:<>
            fields = ["Time","Wave Num","Level"];
            break;
        case 7: //Level Win: Level: <>
            fields = ["Time","Level"];
            break;
        default:
            throw help;
    }

    //collect start time info on players
    var level_starttime = {};
    var level_logs = data["player_quests"];
    for(var i = 0; i < level_logs.length; i++){
        var quest = level_logs[i]["dynamic_quest_id"];
        var starttime = parseInt(level_logs[i]["server_timestamp"]);
        if(!level_starttime.hasOwnProperty(quest)){
            level_starttime[quest] = starttime;
        }
        else if(level_starttime[quest]>starttime){
            level_starttime[quest] = starttime;
        }
    }

    var input = data["player_actions"];
    var output = [];
    for(var i = 0; i < input.length; i++){
        if(input[i]["action_id"] == actType){ //action matches type!
            var entry = {};
            var entryValues = (" "+input[i]["action detail"]).split(regex);

            var quest = input[i]["dynamic quest id"];
            entry[fields[0]] = parseInt(input[i]["log_timestamp"])-level_starttime[quest];
            for(var j = 1; j < fields.length; j++){
                if(isNaN(parseInt(entryValues[j]))){
                    try{
                        entry[fields[j]] = JSON.parse(entryValues[j]);
                        //Hotfix because I forgot to log tower height!
                        entry["Height"] = entry[fields[j]].length;
                    }
                    catch(err){
                        entry[fields[j]] = entryValues[j];
                    }
                }
                else{
                    entry[fields[j]] = parseInt(entryValues[j]);
                }
            }
            output.push(entry);
        }
    }

    return output;
}
