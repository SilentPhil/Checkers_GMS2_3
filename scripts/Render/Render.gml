function Render(_game_controller/*:GameController*/) constructor {
	__game_controller = _game_controller; /// @is {GameController}
	
	__board_shift	= new Point(128, 128);
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
	
	static __get_square_top_left = function(__square/*:Square*/)/*->Point*/ {
		var position = __square.get_position();
		var X = __board_shift.x + position.x * __square_size;
		var Y = __board_shift.y + position.y * __square_size;
		
		return new Point(X, Y);
	}
	
	static draw = function()/*->void*/ {
		var board = __game_controller.get_board();
		
		// Рамка вокруг цвета игрока, чей сейчас ход
		draw_set_color(__piece_color[__game_controller.get_current_player_index()]);
		draw_line_width(0, 0, room_width, 0, 30);
		draw_line_width(room_width, 0, room_width, room_height, 30);
		draw_line_width(room_width, room_height, 0, room_height, 30);
		draw_line_width(0, room_height, 0, 0, 30);
		
		for (var i = 0; i < board.get_width(); i++) {
			for (var j = 0; j < board.get_height(); j++) {
				var square	= board.get_square(i, j);
				var pos		= __get_square_top_left(square);

				if ((i == 0) || (j == board.get_height() - 1)) {
					draw_set_halign(fa_center);
					draw_set_valign(fa_middle);
					draw_set_color(c_ltgray);
					if (i == 0) {
						draw_text(pos.x - __square_size / 2, pos.y + __square_size / 2, square.get_y_notation());
					}
					if (j == board.get_height() - 1) {
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
		
		var current_player = __game_controller.get_current_player();
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
}