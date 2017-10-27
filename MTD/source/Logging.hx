package;

class Logging {
    public function new(){

    }
    static public function initialize(gameId : UInt, versionId : UInt, debugMode : Bool, suppressConsoleOutput : Bool) : Void{
        #if html5
        untyped getLogging().initialize(gameId,versionId,debugMode,suppressConsoleOutput);
        #end
    }
    static public function recordEvent(actionId : UInt, ?actionDetail : String) : Void{
        #if html5
        untyped getLogging().recordEvent(actionId, actionDetail);
        #end
    }
    static public function recordLevelEnd() : Void{
        #if html5
        untyped getLogging().recordLevelEnd();
        #end
    }
    static public function recordLevelStart(questId : Float, ?questDetail : String) : Void{
        #if html5
        untyped getLogging().recordLevelStart(questId, questDetail);
        #end
    }
    static public function recordPageLoad(?userInfo : String) : Void{
        #if html5
        untyped getLogging().recordPageLoad(userInfo);
        #end
    }
}
