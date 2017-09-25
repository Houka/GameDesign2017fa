package;

import gameObjects.GameObject;
import haxe.ds.GenericStack;

/**
 * The RenderBuffer holds a static queue of GameObject that needs to be added to the main game state
 */

class RenderBuffer
{
    static private var buffer:GenericStack<GameObject> = new GenericStack<GameObject>();

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
    	for (i in buffer)
            buffer.remove(i);
    }
}