package controllers;

import gameStates.*; 
import flixel.FlxState; 


class GameStateController
{
	private var states: Array<FlxState> = [LoadingState, MenuState, PauseState, PlayState]; 
	private var currentState: Int; 

	public function new(): Void { 
		currentState = 0; 
		states = [LoadingState, MenuState, PauseState, PlayState]; 
	}

	public function getCurrentState(): FlxState { 
		return new states[currentState](); 
	}

	public function nextState(): Void { 
		currentState += 1;

		if (currentState >= states.length) { 
			currentState = 0; 
		}
	}

}
