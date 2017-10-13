package; 

typedef JsonData = {
	var terrain_map: Array<Array<Int>>; 
    var waves: Array<Array<Int>>;
    var waves_interval: Int; 
    var tutorial_text: String; 
}

class Maps { 
	public static var _1:JsonData = { 
	    terrain_map : 
	        [[0,0,0,0,0,2,2,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,1,1,0,0,0,0,0,0],
			[0,0,0,0,0,3,1,0,0,0,0,0,0]], 
	    waves: 
	        [[0, 1, 0]], 
	    waves_interval: 4, 
	    tutorial_text: 
	        "To build a tower, click on items in the store and then press build. \n Add your tower to your path when you are ready!"
	    }

	public static var _2:JsonData = { 
		terrain_map : 
		    [[0,0,0,2,2,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,1,0,0,0,0,0,0,0],
			[0,0,0,0,1,1,1,1,0,0,0,0,0],
			[0,0,0,0,0,1,1,1,1,1,1,1,0],
			[0,0,0,0,0,0,0,0,0,0,1,1,0],
			[0,0,0,0,0,0,0,0,0,1,1,1,0],
			[0,0,0,0,0,1,1,1,1,1,1,0,0],
			[0,0,0,0,1,1,1,1,1,1,0,0,0],
			[0,0,0,1,1,1,1,0,0,0,0,0,0],
			[0,0,0,0,3,1,0,0,0,0,0,0,0]],
	    waves: 
	        [[10, 0, 0]], 
	    waves_interval: 10, 
	    tutorial_text: 
	        "These enemies are known as walkers and their sole goal is to walk to the exit! \n Protect your homebase at all costs!"
	}

	public static var _3:JsonData = { 
		terrain_map : 
		    [[0,0,0,2,2,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,1,0,0,0,0,0,0,0],
			[0,0,0,0,1,1,1,1,0,0,0,0,0],
			[0,0,0,0,0,1,1,1,1,1,1,1,0],
			[0,0,0,0,0,0,0,0,0,0,1,1,0],
			[0,0,0,0,0,0,0,0,0,1,1,1,0],
			[0,0,0,0,0,1,1,1,1,1,1,0,0],
			[0,0,0,0,1,1,1,1,1,1,0,0,0],
			[0,0,0,1,1,1,1,0,0,0,0,0,0],
			[0,0,0,0,3,1,0,0,0,0,0,0,0]],
	    waves: 
	       	[[0, 10, 0]], 
	    waves_interval: 5, 
	    tutorial_text: 
	        "This enemy type is known as a tank -- they're slower and have a higher HP!"
	}

	public static var _4:JsonData = { 
		terrain_map : 
		    [[0,0,0,2,2,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,1,0,0,0,0,0,0,0],
			[0,0,0,0,1,1,1,1,0,0,0,0,0],
			[0,0,0,0,0,1,1,1,1,1,1,1,0],
			[0,0,0,0,0,0,0,0,0,0,1,1,0],
			[0,0,0,0,0,0,0,0,0,1,1,1,0],
			[0,0,0,0,0,1,1,1,1,1,1,0,0],
			[0,0,0,0,1,1,1,1,1,1,0,0,0],
			[0,0,0,1,1,1,1,0,0,0,0,0,0],
			[0,0,0,0,3,1,0,0,0,0,0,0,0]],
	    waves: 
	       	[[10, 10, 0]], 
	    waves_interval: 10, 
	    tutorial_text: 
	        "Waves of enemies are combinations of multiple enemy types."
	}

	public static var _5:JsonData = { 
		terrain_map : 
			[[0,0,0,2,2,0,0,0,0,0,0,0],
			[0,0,0,1,1,1,1,1,1,0,0,0],
			[0,0,0,0,0,1,1,1,1,0,0,0],
			[0,0,0,0,0,1,1,1,1,1,0,0],
			[0,0,0,0,1,1,1,1,1,1,0,0],
			[0,0,0,1,1,1,0,1,1,1,0,0],
			[0,0,0,1,1,0,0,0,1,1,0,0],
			[0,0,0,1,1,0,0,0,1,1,0,0],
			[0,0,0,0,1,1,0,1,1,1,0,0],
			[0,0,0,0,1,1,1,1,1,0,0,0],
			[0,0,0,0,0,1,1,1,1,0,0,0],
			[0,0,0,0,0,0,0,1,1,0,0,0],
			[0,0,0,0,0,0,0,1,1,0,0,0],
			[0,0,0,0,0,0,0,3,0,0,0,0]], 
	    waves: 
	       	[[20, 20, 0]], 
	    waves_interval: 10, 
	    tutorial_text: 
	        "Watch out for the different paths enemies can take!"
	}

	public static var _6:JsonData = { 
		terrain_map : 
			[[0,0,0,2,2,0,0,0,0,0,0,0,0,0],
			[0,0,0,1,1,1,1,0,0,0,0,0,0,0],
			[0,0,0,1,1,1,1,1,1,0,0,0,0,0],
			[0,0,0,1,1,1,1,1,1,1,1,0,0,0],
			[0,0,0,1,1,0,0,1,1,1,1,0,0,0],
			[0,0,0,1,1,1,0,0,0,1,1,1,0,0],
			[0,0,0,1,1,1,1,0,1,1,1,1,0,0],
			[0,0,0,0,1,1,1,1,1,0,1,1,1,0],
			[0,0,0,0,0,1,1,1,1,0,1,1,1,0],
			[0,0,0,0,0,0,1,1,1,0,1,1,1,0],
			[0,0,0,0,0,0,0,1,1,1,1,1,0,0],
			[0,0,0,0,0,0,0,1,1,1,1,0,0,0],
			[0,0,0,0,0,0,0,1,1,0,0,0,0,0],
			[0,0,0,0,0,0,0,3,1,0,0,0,0,0]], 
	    waves: 
	       	[[20, 20, 20]], 
	    waves_interval: 10, 
	    tutorial_text: 
	        "Enemies can now attack towers placed on paths so beware!"
	}





	

}