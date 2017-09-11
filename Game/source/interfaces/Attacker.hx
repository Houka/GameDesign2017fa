package interfaces;

@:enum
abstract AttackType(Int) {
  var Ground = 0;
  var Air = 1;
}

interface Attacker
{
	public var attackPoints:Int;
	public var attackType:AttackType; 
	public var attackRange:Int;
	public var isAttacking:Bool;
}
