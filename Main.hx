//Sublime installation: haxe package control book 
//https://books.google.com/books?id=mfaoCwAAQBAJ&pg=PA4&lpg=PA4&dq=haxe+package+control&source=bl&ots=PErdDuIBQ-&sig=qcVVlPEghk-7s2E_cVW0YN0leIk&hl=en&sa=X&ved=0ahUKEwjBoPP4poXWAhUCKCYKHcVnAL8Q6AEIUzAI#v=onepage&q=haxe%20package%20control&f=false

class Main { 
	static public function main(): Void {
		var a: Int = 0;
		trace("Hello World");
	}
}

class Point { 
	var x: Int; 
	var y: Int; 

	public function new(x,y) {
		this.x = x; 
		this.y = y;
	}

	public function toString() {
		return "Point(" + x + "," + y + ")"; 
	}
}