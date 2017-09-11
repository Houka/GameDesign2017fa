package gameStates;

import flixel.FlxState;
import flixel.FlxSprite;
import gameObjects.*;
import Math.*;
import interfaces.Movable;
import controllers.*;

class NPCTestState extends FlxState
{
	private var npcs:Array<Worker> = new Array<Worker>();
	private var npcController:WorkerController = new WorkerController(20);

	private function testNPC(x:Int):Void{
		var npc = new Worker(x,10,1,10,AssetPaths.player__png,16,16);
		npc.setGoal(x,200);
		npcController.addAnimation(npc);
		add(npc);
		npcs.push(npc);
	}

	private function testNPCUpdate():Void{
		for(npc in npcs){
			npcController.update(npc);

			//testing movement function
			if(npc.isAtGoal())
				npc.setGoal(100,100);
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
