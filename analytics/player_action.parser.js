function parseAct(data, actType){
    var help = "Parse player actions from data.json, and output a JSON of just those actions.\n"+
        "Input:\n\tdata:raw JSON data; actType:int 1-6\n"+
        "Actions:\n"+
        "\t1: Mouse Press\n"+
        "\t2: Mouse Release\n"+
        "\t3: HP Decrease\n"+
        "\t4: Wave Start\n"+
        "\t5: Tower Create\n"+
        "\t6: Game Over\n";

    if(isNaN(actType)){
        throw help;
    }

    var regex = /[A-Za-z]*\s[A-Za-z]+\:/;
    var fields;
    switch(actType){
        case 1: //Mouse Press: <Date> Level:<> x:<> y:<>/
            fields = ["Time","Level","X","Y"];
            break;
        case 2: //Mouse Release: <Date> Level:<> x:<> y:<>
            fields = ["Time","Level","X","Y"];
            break;
        case 3: //HP Decrease: <Date> Level:<> HP:<>
            fields = ["Time","Level","HP"];
            break;
        case 4: //Wave Start: <Date> Level:<> Money:<> Wave:<> Towers Killed:<>
            fields = ["Time","Level","Money","Wave","Towers Killed"];
            break;
        case 5: //Tower Create: <Date> Level:<> x:<> y:<> Materials:<>
            fields = ["Time","Level","X","Y","Materials"];
            break;
        case 6: //Game Over: Wave num:<> Level:<>
            fields = ["Wave Num","Level"];
            break;
        default:
            throw help;
    }

    var input = data["player_actions"];
    var output = [];
    for(var i = 0; i < input.length; i++){
        if(input[i]["action_id"] == actType){ //action matches type!
            var entry = {};
            var entryValues = input[i]["action detail"].split(regex);
            for(var j = 0; j < fields.length; j++){
                if(actType == 6){ //special case: Game Over log is off by one with regex.
                    entry[fields[j]] = parseInt(entryValues[j+1]);
                }
                else if(isNaN(parseInt(entryValues[j]))){
                    entry[fields[j]] = entryValues[j];
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
