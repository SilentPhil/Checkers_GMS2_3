function Player(_game/*:GameController*/, _side/*:PLAYER_SIDE*/, _brain_type/*:PLAYER_BRAIN*/) constructor {
	__game			= _game;		/// @is {GameController}
	__side			= _side;		/// @is {PLAYER_SIDE}
	__brain_type	= _brain_type;	/// @is {PLAYER_BRAIN}
	
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
	
	static get_side = function()/*->PLAYER_SIDE*/ {
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
}