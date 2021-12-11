function GameController() constructor {
	__players	= [	/// @is {Player[]}
					new Player(self, PLAYER_SIDE.TOP), 
					new Player(self, PLAYER_SIDE.BOTTOM)
				];

	__board 			= new Board(__players);
	__turn				= new Turn(1);
	__current_player	= __players[0]; /// @is {Player}
	
	static next_turn = function()/*->void*/ {
		__current_player = (__current_player == __players[0] ? __players[1] : __players[0]);
	}
	
	static step = function()/*->void*/ {
		var is_player_make_turn = __current_player.step();
		if (is_player_make_turn) {
			next_turn();
		}
	}
	
	static get_board = function()/*->Board*/ {
		return __board;
	}
}


function Player(_game/*:GameController*/, _side/*:PLAYER_SIDE*/) constructor {
	__game = _game; /// @is {GameController}
	__side = _side; /// @is {PLAYER_SIDE}
	__brain = new HumanBrain(self, o_game.render); /// @is {Brain}
	
	static step = function()/*->bool*/ {
		return __brain.step();
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
	
	static step = function()/*->bool*/ {
		return false;
	}
}

function HumanBrain(_player/*:Player*/, _render/*:Render*/) : Brain(_player) constructor {
	__render			= _render;		/// @is {Render}
	__selected_square	= undefined;	/// @is {Square?}
	// __current_state 	= HUMAN_CONTROL_STATE.SELECT_SQUARE; /// @is {HUMAN_CONTROL_STATE}
	__available_squares_for_move = []; /// @is {Square[]}
	
	/// @override
	static step = function()/*->bool*/ {
		if (mouse_check_button_released(mb_left)) {
			var board = __player.get_game().get_board();
			var square_under_mouse/*:Square*/ = __render.get_square_in_point(mouse_x, mouse_y);
			if (square_under_mouse != undefined && square_under_mouse.is_has_piece(__player)) {
				__selected_square = square_under_mouse;
				__available_squares_for_move = board.get_available_turns(__selected_square);
			}
			
			if (__selected_square != undefined && array_find_index(__available_squares_for_move, square_under_mouse) != -1) {
				// move!
				board.move_piece(__selected_square.get_piece(), __selected_square, square_under_mouse);
				__selected_square = undefined;
				__available_squares_for_move = [];
				return true;
			}
		}
		return false;
	}
	
	static get_selected_square = function()/*->Square?*/ {
		return __selected_square;
	}
	
	static get_available_squares_for_move = function()/*->Square[]*/ {
		return __available_squares_for_move;
	}
	
	enum HUMAN_CONTROL_STATE {
		SELECT_SQUARE,
		MAKE_TURN,
	}
}

