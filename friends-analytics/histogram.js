//@author: Katherine Tang

function create_histogram(data, svg) { 
    //console.log(data);

    var min = d3.min(data);
    var max = d3.max(data);

    // Histogram scales
    var xScale = d3.scaleLinear()
        .domain([min, max]).range([50, 550]);
    var yScale = d3.scaleLinear().range([520, 50]);

    // Make histogram bins
    var group = Math.floor(Math.sqrt(data.length));
    var histogram = d3.histogram()
        .value(function(d) { return d; })
        .domain(xScale.domain())
        .thresholds(xScale.ticks(group));
    var bins = histogram(data);


    yScale.domain([0, d3.max(bins, function(d) { return d.length; })])

    // Histogram axes
    var ticks = [];
    bins.forEach(function(d, i) {
        if (i % 2 == 0) {
            ticks.push(d.x0);
        }
    });
    
    var xAxis = d3.axisBottom(xScale).tickValues(ticks)
        .tickFormat(d3.format("1"));       
    svg.append("g")
       .attr("transform", "translate(35, 520)").call(xAxis);
            
    var yAxis = d3.axisLeft(yScale);
    svg.append("g")
       .attr("transform", "translate(80,0)").call(yAxis);

    var margin = {top: 20, right: 20, bottom: 50, left: 70};
    svg.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", "20")
      .attr("x","-300")
      .attr("dy", "1em")
      .style("text-anchor", "middle")
      .text("Number of Players");

    svg.append("text")             
      .attr("transform",
            "translate(370,570)")
      .style("text-anchor", "middle")
      .text("Level Number");

    svg.append("text")             
      .attr("transform",
            "translate(370,50)")
      .style("text-anchor", "middle")
      .text("Number of Players vs Levels");


    // Histogram bars
    svg.selectAll("rect").data(bins)
        .enter().append("rect")
        .attr("class", "bar")
        .attr("x", function(d) { return xScale((d.x0+d.x1)/2.0) + 22; })
        .attr("y", function(d) { return yScale(d.length); })
        .attr("height", function(d) { return 520 - yScale(d.length); })
        .attr("width", 50)
        .attr("fill", "steelblue");
}