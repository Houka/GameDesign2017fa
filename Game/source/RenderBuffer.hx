package;

import gameObjects.GameObject;

/**
 * The RenderBuffer holds a static queue of GameObject that needs to be added to the main game state
 */

class RenderBuffer
{
    static private var buffer:List<GameObject> = new List<GameObject>();

    public static function isEmpty():Bool{
    	return buffer.isEmpty();
    }

    public static function add(obj:GameObject):Void{
    	buffer.add(obj);
    }

    public static function pop():GameObject{
    	return buffer.pop();
    }

    public static function reset():Void{
    	buffer.clear();
    }
}