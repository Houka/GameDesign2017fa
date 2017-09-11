package gameStates;

import flixel.FlxState;
import flixel.FlxSprite;
import gameObjects.*;
import Math.*;
import interfaces.Movable;
import controllers.*;

class NPCTestState extends FlxState
{
	private var npcs:Array<NPC> = new Array<NPC>();
	private var npcController:NPCController = new NPCController();

	private function testNPC(x:Int):Void{
		var npc = new NPC(x,10,1,10,AssetPaths.player__png,16,16);
		npc.setGoal(x,200);
		npc.animation.add("idle", [0], 5, false);
		npc.animation.add("walk", [0,1,2], 5, true);
		add(npc);
		npcs.push(npc);
	}

	private function testNPCUpdate():Void{
		for(npc in npcs){
			npcController.update(npc);
			if(npc.isAtGoal())
				npc.setGoal(400,400);
		}
	}

	override public function create():Void
	{
		super.create();
		testNPC(100);
		testNPC(110);
		testNPC(90);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		testNPCUpdate();
	}
}
