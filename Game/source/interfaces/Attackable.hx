package interfaces;

interface Attackable
{
	private var baseHealth:Int;
	public var healthPoints:Int;
	public function takeDamage(obj:Attacker):Void;
}
