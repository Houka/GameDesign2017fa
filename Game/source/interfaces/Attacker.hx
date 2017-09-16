package interfaces;

@:enum
abstract AttackType(Int) {
  var Ground = 0;
  var Air = 1;
  var Both = 2;
}

interface Attacker
{
	public var attackPoints:Int;
	public var attackType:AttackType; 
	public var attackRange:Int;
	public var isAttacking:Bool;
}
