//author: Virendra
//source: http://www.jquerybyexample.net/2012/06/get-url-parameters-using-jquery.html

function isNormalized(){
    var sPageURL = window.location.search.substring(1);
    var regex = /[\&\?]/;
    var sURLVariables = sPageURL.split(regex);
    for (var i = 0; i < sURLVariables.length; i++) 
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == "normalized") 
        {
            if(sParameterName[1]=="true"){
                return true;
            }
            return false;
        }
    }
    return false;
}

function getLevel(){
    var sPageURL = window.location.search.substring(1);
    var regex = /[\&\?]/;
    var sURLVariables = sPageURL.split(regex);
    for (var i = 0; i < sURLVariables.length; i++) 
    {
        var sParameterName = sURLVariables[i].split('=');
        if (sParameterName[0] == "level") 
        {
            return parseInt(sParameterName[1]);
        }
    }
    return 0;
}
