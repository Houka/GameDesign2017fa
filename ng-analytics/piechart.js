//@author: Yiming Li

function create_piechart(data, svg) { 
	//constants
	console.log(JSON.stringify(data));
	const WIDTH = 400;
	const HEIGHT = 400;

	//styling, positioning, and color mapping
	svg.attr('width', WIDTH)
		.attr('height', HEIGHT);
	var group = svg.append('g')
    	.attr('transform', 'translate('+(WIDTH/2)+','+(HEIGHT/2)+')');

    var colors = ['#1b9e77','#d95f02','#7570b3'];
    var colorScale = d3.scaleOrdinal()
        .range(colors);

    //create donut chart
    var radius = Math.min(WIDTH,HEIGHT)/2;
    var arc = d3.arc()
		.innerRadius(radius/2)
		.outerRadius(radius);
	var pie = d3.pie()
		.value(function(d){return d.count; })
		.sort(null);
	var path = group.selectAll('path')
		.data(pie(data))
		.enter()
		.append('path')
		.attr('d', arc)
		.attr('fill', function(d){return colorScale(d.data.name); });

	//add legend
	const SQUARESIZE = 16;
	const SQUARESPACE = 4;
	//create placeholders of every legend element. var legend holds ALL elements
	var legend = group.selectAll('.mono')
		.data(colorScale.domain())
		.enter()
		.append('g')
		.attr('class', 'mono')
		.attr('transform', function(d, i){
			var height = SQUARESIZE + SQUARESPACE;
			var vOffset = height * colorScale.domain().length/2;
			var h = -2*SQUARESIZE; //arbitrary
			var v = i*height-vOffset;
			return 'translate('+h+','+v+')';
		});
	//add a rect to every legend element
	legend.append('rect')
		.attr('width', SQUARESIZE)
	    .attr('height', SQUARESIZE)
	    .style('fill', colorScale)
	    .style('stroke', colorScale);
	//add text to every legend element
	legend.append('text')
		.attr('x', SQUARESIZE + SQUARESPACE)
		.attr('y', SQUARESIZE - SQUARESPACE) //arbitrary, relative to each container
		.text(function(d){return d; }); //<- will be fed colorScale.domain()
}
