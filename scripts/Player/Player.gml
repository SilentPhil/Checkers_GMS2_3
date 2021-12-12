function Player(_game/*:GameController*/, _side/*:PLAYER_SIDE*/) constructor {
	__game = _game; /// @is {GameController}
	__side = _side; /// @is {PLAYER_SIDE}
	__brain = new BrainHuman(self, o_game.render); /// @is {Brain}
	
	static step = function()/*->void*/ {
		__brain.step();
	}
	
	static get_side = function()/*->PLAYER_SIDE*/ {
		return __side;
	}
	
	static get_game = function()/*->GameController*/ {
		return __game;
	}
	
	static begin_turn = function()/*->void*/ {
		__brain.begin_turn();
	}
}