function Brain(_player/*:Player*/) constructor {
	__player = _player; /// @is {Player}
	
	/// @virtual
	static step = function()/*->void*/ {}
}

function BrainHuman(_player/*:Player*/, _render/*:Render*/) : Brain(_player) constructor {
	__render			= _render;		/// @is {Render}
	__selected_square	= undefined;	/// @is {Square?}
	__available_turns	= new TurnCollection();	/// @is {TurnCollection}
	
	/// @override
	static step = function()/*->void*/ {
		if (mouse_check_button_released(mb_left)) {
			var game	= __player.get_game();
			var board	= game.get_board();
			
			var square_under_mouse/*:Square*/ = __render.get_square_in_point(mouse_x, mouse_y);
			if (square_under_mouse != undefined && square_under_mouse.is_has_piece(__player)) {
				__selected_square = square_under_mouse;
				__available_turns = board.get_available_turns(__selected_square);
			}
			
			if (__selected_square != undefined) {
				var turn/*:Turn*/ = __available_turns.get_turn_by_square_to(square_under_mouse);
				if (turn != undefined) {
					game.accept_turn(turn);
					
					__selected_square = undefined;
					__available_turns = new TurnCollection();
				}
			}
		}
	}
	
	static get_selected_square = function()/*->Square?*/ {
		return __selected_square;
	}
	
	static get_available_turns = function()/*->TurnCollection*/ {
		return __available_turns;
	}
}

function BrainAI(_player/*:Player*/) : Brain(_player) constructor {
	
}