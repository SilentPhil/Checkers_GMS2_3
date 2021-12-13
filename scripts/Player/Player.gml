function Player(_game/*:GameController*/, _side/*:int<PLAYER_SIDE>*/, _brain_type/*:int<PLAYER_BRAIN>*/) constructor {
	__game			= _game;		/// @is {GameController}
	__side			= _side;		/// @is {int<PLAYER_SIDE>}
	__brain_type	= _brain_type;	/// @is {int<PLAYER_BRAIN>}
	
	__brain 		= noone; /// @is {Brain}
	switch (__brain_type) {
		case PLAYER_BRAIN.HUMAN:
			__brain = new BrainHuman(self, __game.get_render());
		break;
		
		case PLAYER_BRAIN.AI:
			__brain = new BrainAI(self);
		break;
	}
	
	static begin_turn = function()/*->void*/ {
		__brain.begin_turn();
	}	
	
	static step = function()/*->void*/ {
		__brain.step();
	}
	
	#region getters
	static get_side = function()/*->int<PLAYER_SIDE>*/ {
		return __side;
	}
	
	static get_game = function()/*->GameController*/ {
		return __game;
	}
	
	static get_brain = function()/*->Brain*/ {
		return __brain;
	}
	
	static is_human = function()/*->bool*/ {
		return (__brain_type == PLAYER_BRAIN.HUMAN);
	}
	#endregion
}

enum PLAYER_SIDE {
	TOP		= 0,
	BOTTOM	= 1
}

enum PLAYER_BRAIN {
	HUMAN,
	AI
}