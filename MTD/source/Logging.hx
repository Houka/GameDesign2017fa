package;

class Logging {
    static private var _isRecording:Bool = false;
    public function new(){

    }
    static public function initialize(gameId : UInt, versionId : UInt, debugMode : Bool, suppressConsoleOutput : Bool) : Void{
        #if html5
        untyped getLogging().initialize(gameId,versionId,debugMode,suppressConsoleOutput);
        #end
    }
    static public function recordEvent(actionId : UInt, ?actionDetail : String) : Void{
        #if html5
        if(_isRecording){
            untyped getLogging().recordEvent(actionId, actionDetail);
        }
        #end
    }
    static public function recordLevelEnd() : Void{
        #if html5
        if(_isRecording){
            untyped getLogging().recordLevelEnd();
            _isRecording = false;
        }
        #end
    }
    static public function recordLevelStart(questId : Float, ?questDetail : String) : Void{
        #if html5
        untyped getLogging().recordLevelStart(questId, questDetail);
        _isRecording = true;
        #end
    }
    static public function recordPageLoad(?userInfo : String) : Void{
        #if html5
        untyped getLogging().recordPageLoad(userInfo);
        #end
    }
    static public function assignABTestValue(candidate:Int): Int{
        #if html5
        return untyped getLogging().assignABTestValue(candidate);
        #else
        return 0;
        #end
    }
    static public function recordABTestValue():Void{
        #if html5
        untyped getLogging().recordABTestValue();
        #end
    }
}
