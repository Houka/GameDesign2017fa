package interfaces;

interface Healable extends Attackable
{
	public function healBy(health:Int):Void;
}
