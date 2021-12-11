function GameController() constructor {
	__players	= [	/// @is {Player[]}
					new Player(self, PLAYER_SIDE.TOP), 
					new Player(self, PLAYER_SIDE.BOTTOM)
				];
	__current_player	= __players[0]; /// @is {Player}

	__board 			= new Board(self);
	__turns_history		= new TurnHistory();
	
	static step = function()/*->void*/ {
		__current_player.step();
		
		if (keyboard_check_pressed(vk_space)) {
			undo_last_turn();
		}
	}
	
	static accept_turn = function(_turn/*:Turn*/)/*->void*/ {
		__board.move_piece(_turn.get_square_from(), _turn.get_square_to());
		if (_turn.is_attack()) {
			__board.delete_piece(_turn.get_square_under_attack());
		}
		
		__turns_history.push_turn(_turn);
		change_current_player();
		
		log(_turn.get_square_from().get_x_notation(), _turn.get_square_from().get_y_notation(), "->", _turn.get_square_to().get_x_notation(), _turn.get_square_to().get_y_notation());
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
	
	static get_players = function()/*->Player[]*/ {
		return __players;
	}
	
	static get_current_player_index = function()/*->number*/ {
		return array_find_index(__players, __current_player);
	}
	
	static get_other_player = function(_player/*:Player*/)/*->Player*/ {
		return (_player == __players[0] ? __players[1] : __players[0]);
	}	
}