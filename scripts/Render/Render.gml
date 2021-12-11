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
	
	static draw = function()/*->void*/ {
		var board = __game_controller.get_board();
		
		for (var i = 0; i < board.get_width(); i++) {
			for (var j = 0; j < board.get_height(); j++) {
				var square = board.get_square(i, j);
				var X = __board_shift.x + i * __square_size;
				var Y = __board_shift.y + j * __square_size;
				
				// Square
				draw_set_color(__square_color[/*#cast*/ square.get_color()]);
				draw_rectangle(X, Y, X + __square_size, Y + __square_size, false);
				
				// Piece
				if (square.is_has_piece()) {
					var piece/*:Piece*/ = square.get_piece();
					draw_set_color(__piece_color[/*#cast*/ piece.get_color()]);
					draw_circle(X + __square_size / 2, Y + __square_size / 2, __piece_size, piece.is_king());
					// draw_ellipse(X, Y, X + __square_size, Y + __square_size, piece.is_king());
				}
			}
		}
		
		var current_player = __game_controller.__current_player;
		var selected_square/*:Square*/ = (/*#cast*/ current_player.__brain /*#as HumanBrain*/).get_selected_square();
		if (selected_square != undefined) {
			var position = selected_square.get_position();
			var X = __board_shift.x + position.x * __square_size;
			var Y = __board_shift.y + position.y * __square_size;
			draw_set_color(c_red);
			draw_rectangle(X, Y, X + __square_size, Y + __square_size, true);
		}
		var available_squares_for_move = (/*#cast*/ current_player.__brain /*#as HumanBrain*/).get_available_squares_for_move();
		for (var i = 0, size_i = array_length(available_squares_for_move); i < size_i; i++) {
			var available_square = available_squares_for_move[i];
			var position = available_square.get_position();
			var X = __board_shift.x + position.x * __square_size;
			var Y = __board_shift.y + position.y * __square_size;
			draw_set_color(c_yellow);
			draw_rectangle(X, Y, X + __square_size, Y + __square_size, true);
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