function GameController() constructor {
	__players	= [	/// @is {Player[]}
					new Player(self, PLAYER_SIDE.TOP), 
					new Player(self, PLAYER_SIDE.BOTTOM)
				];
	__current_player	= __players[PLAYER_SIDE.BOTTOM]; /// @is {Player}

	__board 			= new Board(self);
	__turns_history		= new TurnHistory();
	
	__begin_turn();
	
	static __begin_turn = function()/*->void*/ {
		__current_player.begin_turn();
	}
	
	static step = function()/*->void*/ {
		__current_player.step();
		
		if (keyboard_check_pressed(vk_space)) {
			__undo_last_turn();
		}
	}
	
	static accept_turn = function(_turn/*:Turn*/)/*->void*/ {
		__board.move_piece(_turn.get_square_from(), _turn.get_square_to());
		if (_turn.is_attack()) {
			__board.delete_piece(_turn.get_square_under_attack());
		}
		if (_turn.is_crowned_turn()) {
			_turn.get_piece().set_king(true);
		}
		__change_current_player();
		__turns_history.push_turn(_turn);
		__begin_turn();
		
		log(_turn.get_square_from().get_x_notation(), _turn.get_square_from().get_y_notation(), "->", _turn.get_square_to().get_x_notation(), _turn.get_square_to().get_y_notation());
		/// @todo Нужно предусмотреть правило Турецкого удара https://ru.wikipedia.org/wiki/Турецкий_удар, когда буду делать ходы дамки
		
	}
	
	static __undo_last_turn = function()/*->void*/ {
		var last_turn/*:Turn*/ = __turns_history.get_last_turn();
		if (last_turn != undefined) { 
			__board.move_piece(last_turn.get_square_to(), last_turn.get_square_from());
			if (last_turn.is_attack()) {
				(last_turn.get_square_under_attack() /*#as Square*/).set_piece(last_turn.get_piece_under_attack());
			}
			if (last_turn.is_crowned_turn()) {
				last_turn.get_piece().set_king(false);
			}
			__current_player = last_turn.get_player();
			__turns_history.delete_last_turn();
			__begin_turn();
		}
	}
	
	static __change_current_player = function()/*->void*/ {
		__current_player = get_other_player_for(__current_player);
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
	
	static get_other_player_for = function(_player/*:Player*/)/*->Player*/ {
		return (_player == __players[PLAYER_SIDE.TOP] ? __players[PLAYER_SIDE.BOTTOM] : __players[PLAYER_SIDE.TOP]);
	}	
}