function GameController() constructor {
	__render			= new Render(self);
	
	__players			= [	/// @is {Player[]}
							new Player(self, PLAYER_SIDE.TOP,		PLAYER_BRAIN.AI), 
							new Player(self, PLAYER_SIDE.BOTTOM,	PLAYER_BRAIN.HUMAN)
						];
	__current_player	= __players[PLAYER_SIDE.BOTTOM]; /// @is {Player}

	__board 			= new Board(self);
	__turns_history		= new TurnHistory();
	
	__begin_new_turn();
	
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
		__turns_history.push_turn(_turn);
		
		var is_can_continue_attack = (_turn.is_attack() && __board.get_available_turns(__current_player, _turn.get_square_to()).is_have_attack_turns());
		if (is_can_continue_attack) {
			__begin_new_turn(_turn.get_square_from());
		} else {
			__change_current_player();
			__begin_new_turn();
		}
	}
	
	static __begin_new_turn = function(_square_from/*:Square*/ = undefined)/*->void*/ {
		__current_player.begin_turn();
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
	
	static get_current_player_index = function()/*->number*/ {
		return array_find_index(__players, __current_player);
	}
	
	static get_other_player_for = function(_player/*:Player*/)/*->Player*/ {
		return (_player == __players[PLAYER_SIDE.TOP] ? __players[PLAYER_SIDE.BOTTOM] : __players[PLAYER_SIDE.TOP]);
	}	
	
	static get_current_player = function()/*->Player*/ {
		return __current_player;
	}
	
	static get_render = function()/*->Render*/ {
		return __render;
	}
	#endregion
}