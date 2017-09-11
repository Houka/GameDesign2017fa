package interfaces;

enum AttackType{
	Ground;
	Air;
}

interface Attacker
{
	public var attackPoints:Int;
	public var attackType:AttackType; 
	public function isAttacking():Bool;
}
