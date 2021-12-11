function GameController() constructor {
	__players	= [	/// @is {Player[]}
					new Player(self, PLAYER_SIDE.TOP), 
					new Player(self, PLAYER_SIDE.BOTTOM)
				];

	__turns_history		= new TurnHistory();
	__board 			= new Board(__players);
	__current_player	= __players[0]; /// @is {Player}
	
	static step = function()/*->void*/ {
		__current_player.step();
		
		if (keyboard_check_pressed(vk_space)) {
			undo_last_turn();
		}
	}
	
	static perform_turn = function(_turn/*:Turn*/)/*->void*/ {
		__board.move_piece(_turn.get_square_from(), _turn.get_square_to());
		if (_turn.is_attack()) {
			__board.delete_piece(_turn.get_square_under_attack());
		}
		
		__turns_history.push_turn(_turn);
		
		change_current_player();
	}
	
	static undo_last_turn = function()/*->void*/ {
		var last_turn/*:Turn*/ = __turns_history.get_last_turn();
		if (last_turn != undefined) { 
			__board.move_piece(last_turn.get_square_to(), last_turn.get_square_from());
			if (last_turn.is_attack()) {
				(last_turn.get_square_under_attack() /*#as Square*/).set_piece(last_turn.get_piece_under_attack());
			}
			
			__current_player = last_turn.get_player();
			
			__turns_history.delete_last_turn();
		}
	}
	
	static change_current_player = function()/*->void*/ {
		__current_player = (__current_player == __players[0] ? __players[1] : __players[0]);
	}	
	
	static get_board = function()/*->Board*/ {
		return __board;
	}
	
	static get_current_player = function()/*->Player*/ {
		return __current_player;
	}
	
	static get_current_player_index = function()/*->number*/ {
		return array_find_index(__players, __current_player);
	}
}


function Player(_game/*:GameController*/, _side/*:PLAYER_SIDE*/) constructor {
	__game = _game; /// @is {GameController}
	__side = _side; /// @is {PLAYER_SIDE}
	__brain = new HumanBrain(self, o_game.render); /// @is {Brain}
	
	static step = function()/*->void*/ {
		__brain.step();
	}
	
	static get_side = function()/*->PLAYER_SIDE*/ {
		return __side;
	}
	
	static get_game = function()/*->GameController*/ {
		return __game;
	}
}

function Brain(_player/*:Player*/) constructor {
	__player = _player; /// @is {Player}
	
	static step = function()/*->void*/ {}
}

function HumanBrain(_player/*:Player*/, _render/*:Render*/) : Brain(_player) constructor {
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
					game.perform_turn(turn);
					
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
	
	enum HUMAN_CONTROL_STATE {
		SELECT_SQUARE,
		MAKE_TURN,
	}
}

