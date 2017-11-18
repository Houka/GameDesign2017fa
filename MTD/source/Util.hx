package utils;

import flixel.math.FlxPoint;

class Util{
	public static inline var TILE_SIZE:Int = 64;
	public static function loadCSV(MapData:String):Array<Array<Int>>{
		var _data:Array<Array<Int>>;

		// path to map data file?
		if (Assets.exists(MapData))
		{
			MapData = Assets.getText(MapData);
		}
		
		// Figure out the map dimensions based on the data string
		_data = new Array<Array<Int>>();
		var columns:Array<String>;
		
		var regex:EReg = new EReg("[ \t]*((\r\n)|\r|\n)[ \t]*", "g");
		var lines:Array<String> = regex.split(MapData);
		var rows:Array<String> = lines.filter(function(line) return line != "");
		
		for (rowString in rows)
		{
			var row:Array<Int> = new Array<Int>();
			if (rowString.endsWith(","))
				rowString = rowString.substr(0, rowString.length - 1);
			columns = rowString.split(",");

			for (columnString in columns)
			{
				//the current tile to be added:
				var curTile = Std.parseInt(columnString);
				
				if (curTile == null)
					throw 'String is not a valid integer: "$columnString"';
				
				row.push(curTile);
			}

			_data.push(row);
		}

		return _data;
	}

	public static function toMapCoordinates(x:Float, y:Float):FlxPoint{
		return FlxPoint.get(Std.int(x/TILE_SIZE), Std.int(y/TILE_SIZE));
	}
	
	/*  Returns the screen coordinates with respect to the camera
	*   x = the column position in map coordinates
	*   y = the row position in map coordinates
	*   where the first column and row is index 0
	*/
	public static function toCameraCoordinates(x:Int, y:Int):FlxPoint{
		return FlxPoint.get(x*TILE_SIZE, y*TILE_SIZE);
	}

	public static function copy2DArray(array:Array<Array<Int>>):Array<Array<Int>>{
		var copy = new Array<Array<Int>>();
		for (i in array){
			copy.push(i.copy());
		}
		return copy;
	}

	public static function copyPathFrom(Path:Array<FlxPoint>,Index:Int):Array<FlxPoint>{
		var result:Array<FlxPoint> = new Array<FlxPoint>();
		var tempPoint:FlxPoint;
		for (i in Index...Path.length){
			tempPoint = new FlxPoint(Path[i].x,Path[i].y);
			result.push(tempPoint);
		}

		return result;
	 }
}