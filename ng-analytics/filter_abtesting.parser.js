function filterAB(data){
    //build player_id:ab_test_value dictionary
    var ab_dict = {};
    var ab_data = data["abtesting"];
    for(var i = 0; i < ab_data.length; i++){
        ab_dict[ab_data[i]["user_id"]] = parseInt(ab_data[i]["ab_testing_value"]);
    }

    var a_output = {};
    var b_output = {};

    //filter page loads
    a_output["page_loads"] = [];
    b_output["page_loads"] = [];
    var page_loads = data["page_loads"];
    for(var i = 0; i < page_loads.length; i++){
        var player_id = page_loads[i]["user_id"];
        if(ab_dict.hasOwnProperty(player_id)){
            if(ab_dict[player_id]==1){
                a_output["page_loads"].push(page_loads[i]);
            }
            else if(ab_dict[player_id]==2){
                b_output["page_loads"].push(page_loads[i]);
            }
        }
    }

    //filter player quests
    a_output["player_quests"] = [];
    b_output["player_quests"] = [];
    var player_quests = data["player_quests"];
    for(var i = 0; i < player_quests.length; i++){
        var player_id = player_quests[i]["user_id"];
        if(ab_dict.hasOwnProperty(player_id)){
            if(ab_dict[player_id]==1){
                a_output["player_quests"].push(player_quests[i]);
            }
            else if(ab_dict[player_id]==2){
                b_output["player_quests"].push(player_quests[i]);
            }
        }
    }

    //filter player actions
    a_output["player_actions"] = [];
    b_output["player_actions"] = [];
    var player_actions = data["player_actions"];
    for(var i = 0; i < player_actions.length; i++){
        var player_id = player_actions[i]["user_id"];
        if(ab_dict.hasOwnProperty(player_id)){
            if(ab_dict[player_id]==1){
                a_output["player_actions"].push(player_actions[i]);
            }
            else if(ab_dict[player_id]==2){
                b_output["player_actions"].push(player_actions[i]);
            }
        }
    }

    return [a_output, b_output];
}
