const https = require('https');
const http = require('http');
const fs = require('fs');

var version = parseInt(process.argv[2]);
var count = parseInt(process.argv[3]);

if(isNaN(version) || isNaN(count)){
    var help = "Fetch raw JSON data from the GDIAC server.\n"+
    "Usage:\n\t node fetch_data.js <version> <count>";
    console.log(help);
    process.exit();
}

var getUrl = "http://gdiac.cs.cornell.edu/cs4154/fall2017/get_data.php?game_id=771&version_id="+version+"&show_html=no&count="+count;

//MAIN: get JSON data, then call processData
var req = http.get(getUrl, function(res){
    let body = "";
    res.on('data', function(chunk){
        body += chunk;
    });
    res.on('end', function(){
        jsonData = JSON.parse(body);
        output = JSON.stringify(jsonData, null, 2);
        fs.writeFile("data.v"+version+".json", output, function(e){
            if(e){
                console.log(e);
            }
        });
    });
});
req.on('error', function(e){
    console.log(e);
});
req.end();