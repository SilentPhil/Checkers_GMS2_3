function Brain(_player/*:Player*/) constructor {
	__player = _player; /// @is {Player}
	
	__selected_square	= undefined;	/// @is {Square?}
	__available_turns	= new TurnCollection();	/// @is {TurnCollection}
		
	/// @virtual
	static step = function()/*->void*/ {}
	
	static begin_turn = function(_selected_square/*:Square*/ = undefined)/*->void*/ {
		__available_turns = __player.get_game().get_board().get_available_turns(__player, _selected_square);
		__selected_square = _selected_square;
	}
	
	static __make_turn = function(_turn/*:Turn*/)/*->void*/ {
		__selected_square = undefined;
		__available_turns = new TurnCollection();
		
		__player.get_game().accept_turn(_turn);		
	}	
	
	#region getters
	static get_selected_square = function()/*->Square?*/ {
		return __selected_square;
	}
	
	static get_available_turns = function()/*->TurnCollection*/ {
		return __available_turns;
	}	
	#endregion
}

function BrainHuman(_player/*:Player*/, _render/*:Render*/) : Brain(_player) constructor {
	__render = _render;		/// @is {Render}

	/// @override
	static step = function()/*->void*/ {
		if (mouse_check_button_released(mb_left)) {
			var game	= __player.get_game();
			var board	= game.get_board();
			
			var square_under_mouse/*:Square*/ = __render.get_square_in_point(mouse_x, mouse_y);
			if (square_under_mouse != undefined && square_under_mouse.is_has_piece(__player)) {
				__selected_square = square_under_mouse;
			}
			
			if (__selected_square != undefined) {
				var turn/*:Turn*/ = __available_turns.find_turn(__selected_square, square_under_mouse);
				if (turn != undefined) {
					__make_turn(turn);
				}
			}
		}
	}
}

function BrainAI(_player/*:Player*/) : Brain(_player) constructor {
	__turn_delay_timer = new Timer(35);
	
	/// @override
	static step = function()/*->void*/ {
		// Самый простейший "ИИ" - выбирает случайный доступный ход 
		if (__turn_delay_timer.is_done()) {
			__turn_delay_timer.reset();
			
			var turn/*:Turn*/ = __available_turns.get_random();
			if (turn != undefined) {
				__make_turn(turn);
			}
		}
	}
}