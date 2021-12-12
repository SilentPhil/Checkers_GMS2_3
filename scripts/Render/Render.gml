function Render(_game_controller/*:GameController*/) constructor {
	__game_controller = _game_controller; /// @is {GameController}
	
	__board_shift	= new Point(128, 128);
	__game_field	= new Point(640, 640);
	__square_size	= 48;
	__piece_size	= (__square_size * 0.8) / 2;
	
	__square_color	= [
		/*#*/0x462E1C, 
		/*#*/0xFFDFEB
	];
	__piece_color	= [
		/*#*/0xA67B12,	
		/*#*/0x8D77F4
	];
	
	static draw = function()/*->void*/ {
		switch (__game_controller.get_game_state()) {
			case GAME_STATE.PLAY:
				__draw_gameplay();
			break;
			
			case GAME_STATE.END:
				__draw_game_end();
			break;
		}
	}
	
	static __draw_gameplay = function()/*->void*/ {
		var board = __game_controller.get_board();
		var current_player = __game_controller.get_current_player();
		
		// Рамка вокруг цвета игрока, чей сейчас ход
		__draw_border(__piece_color[__game_controller.get_player_index(current_player)], 30);
		
		for (var i = 0; i < board.get_width(); i++) {
			for (var j = 0; j < board.get_height(); j++) {
				var square	= board.get_square(i, j);
				var pos		= __get_square_top_left(square);

				// Подписи к клеткам (1, 2, 3,.., a, b, c,..)
				var is_first_column = (i == 0);
				var is_last_row 	= (j == board.get_height() - 1);
				if (is_first_column || is_last_row) {
					draw_set_halign(fa_center);
					draw_set_valign(fa_middle);
					draw_set_color(c_ltgray);
					if (is_first_column) {
						draw_text(pos.x - __square_size / 2, pos.y + __square_size / 2, square.get_y_notation());
					}
					if (is_last_row) {
						draw_text(pos.x + __square_size / 2, pos.y + __square_size * 1.5, square.get_x_notation());
					}
				}

				// Клетки
				draw_set_color(__square_color[/*#cast*/ square.get_color()]);
				draw_rectangle(pos.x, pos.y, pos.x + __square_size, pos.y + __square_size, false);
				
				// Шашки
				if (square.is_has_piece()) {
					var piece/*:Piece*/ = square.get_piece();
					draw_set_color(__piece_color[/*#cast*/ piece.get_color()]);
					draw_circle(pos.x + __square_size / 2, pos.y + __square_size / 2, __piece_size, piece.is_king());
				}
			}
		}
		
		if (current_player.is_human()) {
			var brain/*:BrainHuman*/ = /*#cast*/ current_player.get_brain();
			
			// Выбранная шашка
	 		var selected_square/*:Square*/ = brain.get_selected_square();
			if (selected_square != undefined) {
				var pos = __get_square_top_left(selected_square);
				draw_set_color(c_red);
				draw_rectangle(pos.x, pos.y, pos.x + __square_size, pos.y + __square_size, true);
			}
			
			var available_turns = brain.get_available_turns();
			var array_of_available_turns = available_turns.get_array_of_turns();
			for (var i = 0, size_i = array_length(array_of_available_turns); i < size_i; i++) {
				var available_turn = array_of_available_turns[i];
				if (available_turn.get_square_from() == selected_square) {
					// Куда можно походить выбранной шашкой
					var pos = __get_square_top_left(available_turn.get_square_to());
					draw_set_color(c_yellow);
					draw_rectangle(pos.x, pos.y, pos.x + __square_size, pos.y + __square_size, true);
					
					// Кто будет срублен атакой выбранной шашкой
					if (available_turn.is_attack()) {
						var pos = __get_square_top_left(available_turn.get_square_under_attack());
						draw_set_color(c_red);
						draw_cross(pos.x + __square_size / 2, pos.y + __square_size / 2, __square_size / 2, 2, 45);
					}
				} else {
					// Шашки, которые могут походить
					var pos = __get_square_top_left(available_turn.get_square_from());
					draw_set_color(c_green);
					draw_rectangle(pos.x + 5, pos.y + 5, pos.x + __square_size - 5, pos.y + __square_size - 5, true);
				}
			}
		}
	}
	
	static __draw_game_end = function()/*->void*/ {
		var winner/*:Player*/ = __game_controller.get_winner();
		if (winner != undefined) {
			var player_index = __game_controller.get_player_index(winner);
			var player_color = __piece_color[player_index];
			__draw_border(player_color, 150);
			
			draw_set_color(player_color);
			draw_set_halign(fa_center);
			draw_set_valign(fa_middle);
			draw_text(__game_field.x / 2, __game_field.y / 2, 
					"Player " + string(player_index + 1) + " won!\n\n" +
					"Press any key to new game..."
				);
			
		}
	}
	
	
	static __draw_border = function(_color/*:number*/, _width/*:number*/)/*->void*/ {
		draw_set_color(_color);
		draw_line_width(0,				0,				__game_field.x, 0,				_width);
		draw_line_width(__game_field.x, 0,				__game_field.x, __game_field.y,	_width);
		draw_line_width(__game_field.x, __game_field.y, 0,				__game_field.y,	_width);
		draw_line_width(0,				__game_field.y, 0,				0,				_width);
	}	
	
	#region getters
	static __get_square_top_left = function(__square/*:Square*/)/*->Point*/ {
		var position = __square.get_position();
		var X = __board_shift.x + position.x * __square_size;
		var Y = __board_shift.y + position.y * __square_size;
		
		return new Point(X, Y);
	}	
	
	static get_square_in_point = function(_x/*:number*/, _y/*:number*/)/*->Square?*/ {
		var board = __game_controller.get_board();
		var X = ceil((_x - __board_shift.x) / __square_size) - 1;
		var Y = ceil((_y - __board_shift.y) / __square_size) - 1;
		
		if (point_in_rectangle(X, Y, 0, 0, board.get_width() - 1, board.get_height() - 1)) {
			return board.get_square(X, Y);
		}  else {
			return undefined;
		}
	}
	#endregion
}