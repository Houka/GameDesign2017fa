//@author: Nicole Tan

function create_burnout(data, svg) { 
	//<line graph (x:levels completed y:player num)>
	//aggregate the number of players who finish each level 

	//for player_quests [and not player_actions]
	//user_id is the same throughout right?
	//we said that end_timestamp - server_stamp is total time player [across levels?]
	//does quest_id mean the final level played by the person

	//% remaining, level
	var height = 500; 
	var width = 500; 
	var padding = 50; 
	
	var xScale = d3.scale.linear()
				.domain([0, 11])
				.range([padding, width-30]); 
	var yScale = d3.scale.linear()
				.domain([0, 100])
				.range([height-padding, 30])

	var xAxis = d3.svg.axis().scale(xScale).orient("bottom"); 
	var yAxis = d3.svg.axis().scale(yScale).orient("left");

	svg.append("g").attr("transform", "translate(0," + (height-padding) + ")")
		.attr("class", "axis")
		.call(xAxis);

	svg.append("g").attr("transform", "translate(" + padding + ",0)")
		.attr("class", "axis")
		.call(yAxis);

	svg.append("text")
		.attr("text-anchor", "middle")
		.attr("transform", "translate(" + (padding/2) + ","+(height/2)+")rotate(-90)")
		.text("% Remaining");

	svg.append("text")
		.attr("text-anchor", "middle")
		.attr("transform", "translate(" + (width/2) + ","+(height-(padding/3))+")")
		.text("Level");






	//<line graph (x:time y:player num)>

}