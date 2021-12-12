function GameController() constructor {
	__render			= new Render(self);
	
	__players			= [	/// @is {Player[]}
							new Player(self, PLAYER_SIDE.TOP,		PLAYER_BRAIN.AI), 
							new Player(self, PLAYER_SIDE.BOTTOM,	PLAYER_BRAIN.HUMAN)
						];
	__current_player	= __players[PLAYER_SIDE.BOTTOM]; /// @is {Player}

	__board 			= new Board(self);
	__turns_history		= new TurnHistory();
	__game_state		= GAME_STATE.PLAY;
	__game_winner		= undefined; /// @is {Player?}
	
	__begin_new_turn();
	
	static step = function()/*->void*/ {
		switch (__game_state) {
			case GAME_STATE.PLAY:
				__current_player.step();
				
				if (keyboard_check_pressed(vk_space)) {
					__undo_last_turn();
				}
				if (keyboard_check_pressed(ord("R"))) {
					__restart();
				}
			break;
			
			case GAME_STATE.END:
				if (keyboard_check_pressed(vk_anykey)) {
					__restart();
				}
			break;
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
		__turns_history.push_turn(_turn);
		
		var is_can_continue_attack = (_turn.is_attack() && __board.get_available_turns(__current_player, _turn.get_square_to()).is_have_attack_turns());
		if (is_can_continue_attack) {
			__begin_new_turn(_turn.get_square_from());
		} else {
			__change_current_player();
			__begin_new_turn();
		}
		
		__check_game_end();
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
			
			__begin_new_turn();
		}
	}	
	
	static __restart = function()/*->void*/ {
		__board	= new Board(self);
		__turns_history.clear();
		__game_state		= GAME_STATE.PLAY;
		__current_player	= __players[PLAYER_SIDE.BOTTOM];
		__begin_new_turn();
	}
	
	static __check_game_end = function()/*->void*/ {
		var player_top		= __players[PLAYER_SIDE.TOP];
		var player_bottom	= __players[PLAYER_SIDE.BOTTOM];
		
		var is_no_pieces_player_top = array_is_empty(__board.get_array_of_pieces_squares_for_player(player_top));
		var is_no_turns_player_top	= __board.get_available_turns(player_top).is_empty();
		if (is_no_pieces_player_top || is_no_turns_player_top) {
			__game_end(player_bottom);
			return;
		}	
		var is_no_pieces_player_bottom	= array_is_empty(__board.get_array_of_pieces_squares_for_player(player_bottom));
		var is_no_turns_player_bottom	= __board.get_available_turns(player_bottom).is_empty();
		if (is_no_pieces_player_bottom || is_no_turns_player_bottom) {
			__game_end(player_top);
			return;
		}
		// Сюда еще можно добавить остальные варианты завершения игры, будь то ходьба дамкой > 15 ходов подряд и т.д. См. википедию.
	}
	
	static __game_end = function(_winner/*:Player?*/)/*->void*/ {
		__game_state	= GAME_STATE.END;
		__game_winner	= _winner;
	}
	
	static __begin_new_turn = function(_square_from/*:Square*/ = undefined)/*->void*/ {
		__current_player.begin_turn();
	}	
	
	static __change_current_player = function()/*->void*/ {
		__current_player = get_other_player_for(__current_player);
	}	
	
	#region getters
	static get_board = function()/*->Board*/ {
		return __board;
	}
	
	static get_players = function()/*->Player[]*/ {
		return __players;
	}

	static get_other_player_for = function(_player/*:Player*/)/*->Player*/ {
		return (_player == __players[PLAYER_SIDE.TOP] ? __players[PLAYER_SIDE.BOTTOM] : __players[PLAYER_SIDE.TOP]);
	}	
	
	static get_current_player = function()/*->Player*/ {
		return __current_player;
	}
	
	static get_player_index = function(_player/*:Player*/)/*->number*/ {
		return array_find_index(__players, _player);
	}
	
	static get_render = function()/*->Render*/ {
		return __render;
	}
	
	static get_winner = function()/*->Player?*/ {
		return __game_winner;
	}
	
	static get_game_state = function()/*->GAME_STATE*/ {
		return __game_state;
	}
	#endregion
}

enum GAME_STATE {
	PLAY,
	END
}