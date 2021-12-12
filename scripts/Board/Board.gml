function Board(_game/*:GameController*/) constructor {
	__game		= _game;				/// @is {GameController}
	__players	= __game.get_players();	/// @is {Player[]}
	__squares	= [];					/// @is {Square[][]}
	__width		= 8;
	__height	= 8;
	
	// Расстановка клеток
	for (var i = 0; i < __width; i++) {
		for (var j = 0; j < __height; j++) {
			var color = /*#cast*/ ((1 + i mod 2 + j mod 2) mod 2) /*#as SQUARE_COLOR*/;
			__squares[i][j] = new Square(self, i, j, color);
		}
	}
	
	// Определение соседей у клеток
	for (var i = 0; i < __width; i++) {
		for (var j = 0; j < __height; j++) {
			var square = __squares[i][j];
			if (square.is_black()) {
				square.__neighbours[@ DIRECTION.NW] = array_get_2d_safe(__squares, i - 1, j - 1);
				square.__neighbours[@ DIRECTION.NE] = array_get_2d_safe(__squares, i + 1, j - 1);
				square.__neighbours[@ DIRECTION.SE] = array_get_2d_safe(__squares, i + 1, j + 1);
				square.__neighbours[@ DIRECTION.SW] = array_get_2d_safe(__squares, i - 1, j + 1);
			}
		}
	}
	
	// Расстановка шашек
	var pieces_lines_width = 3;
	for (var i = 0; i < __width; i++) {
		for (var j = 0; j < __height; j++) {
			var square = __squares[i][j];
			if (square.is_black()) {
				if (j < pieces_lines_width) {
					square.set_piece(new Piece(PIECE_COLOR.BLACK, __players[PLAYER_SIDE.TOP]));
				} else if (j >= __height - pieces_lines_width) {
					square.set_piece(new Piece(PIECE_COLOR.WHITE, __players[PLAYER_SIDE.BOTTOM]));
				}
			}
		}
	}
	
	static move_piece = function(_old_square/*:Square*/, _new_square/*:Square*/)/*->void*/ {
		_new_square.set_piece(_old_square.get_piece());
		_old_square.reset_piece();
	}
	
	static delete_piece = function(_square/*:Square*/)/*->void*/ {
		_square.reset_piece();
	}
	
	static get_available_turns = function(_player/*:Player*/)/*->TurnCollection*/ {
		var available_turns 		= new TurnCollection();
		var array_of_pieces_squares = get_array_of_pieces_squares_for_player(_player);
		
		for (var i = 0, size_i = array_length(array_of_pieces_squares); i < size_i; i++) {
			__fill_turns_collection_with_available_attack(available_turns, array_of_pieces_squares[i]);
		}		
		
		if (available_turns.is_empty()) {
			for (var i = 0, size_i = array_length(array_of_pieces_squares); i < size_i; i++) {
				__fill_turns_collection_with_available_move(available_turns, array_of_pieces_squares[i]);
			}
		}
		
		return available_turns;
	}
	
	static get_array_of_pieces_squares_for_player = function(_player/*:Player*/)/*->Square[]*/ {
		/// @todo Каждый раз приходится пересчитывать шашки
		var arr/*:Square[]*/ = [];
			
		for (var i = 0; i < __width; i++) {
			for (var j = 0; j < __height; j++) {
				var square = __squares[i][j];
				if (square.is_has_piece(_player)) {
					array_push(arr, square);
				}
			}
		}
		
		return arr;
	}
	
	static __fill_turns_collection_with_available_attack = function(_turn_collection/*:TurnCollection*/, _square_attack_from/*:Square*/)/*->void*/ {
		if (_square_attack_from.is_has_piece()) {
			var piece/*:Piece*/ = _square_attack_from.get_piece();
			var player		= piece.get_player();
					
			var available_attack_directions/*:array<DIRECTION>*/ = [DIRECTION.NW, DIRECTION.NE, DIRECTION.SW, DIRECTION.SE];
			if (!piece.is_king()) {
				for (var i = 0, size_i = array_length(available_attack_directions); i < size_i; i++) {
					var attack_direction			= available_attack_directions[i];
					var square_under_attack/*:Square*/	= _square_attack_from.get_neighbour(attack_direction);
					if (square_under_attack != undefined && square_under_attack.is_has_piece(__game.get_other_player_for(player))) {
						// В этом поле находится фишка врага, нужно посмотреть, можно ли ее перепрыгнуть в том же направлении
						var square_attack_to/*:Square*/ = square_under_attack.get_neighbour(attack_direction);
						if (square_attack_to != undefined) {
							if (!square_attack_to.is_has_piece()) {
								_turn_collection.push_turn(new Turn(player, _square_attack_from, square_attack_to, square_under_attack));
							}
						}
					}
				}
			} else {
				for (var i = 0, size_i = array_length(available_attack_directions); i < size_i; i++) {
					var attack_direction	= available_attack_directions[i];
					var square_attack_from	= _square_attack_from;
					while (square_attack_from != undefined) {
						var square_under_attack/*:Square*/ = square_attack_from.get_neighbour(attack_direction);
						if (square_under_attack != undefined) {
							if (square_under_attack.is_has_piece(__game.get_other_player_for(player))) {
								// В этом поле находится фишка врага, нужно посмотреть, можно ли ее перепрыгнуть в том же направлении
								var square_attack_to/*:Square*/ = square_under_attack.get_neighbour(attack_direction);
								while (square_attack_to != undefined) {
									if (!square_attack_to.is_has_piece()) {
										_turn_collection.push_turn(new Turn(player, _square_attack_from, square_attack_to, square_under_attack));
									} else {
										break;
									}
									square_attack_to = square_attack_to.get_neighbour(attack_direction);
								}
							} else if (square_under_attack.is_has_piece(player)) {
								break;
							}
						}
						square_attack_from = square_under_attack;
					}
				}
			}
		}
	}
	
	static __fill_turns_collection_with_available_move = function(_turn_collection/*:TurnCollection*/, _square_move_from/*:Square*/)/*->void*/ {
		if (_square_move_from.is_has_piece()) {
			var piece/*:Piece*/ = _square_move_from.get_piece();
			var player		= piece.get_player();
			
			if (!piece.is_king()) {
				var available_movement_directions/*:array<DIRECTION>*/ = piece.get_available_movement_directions();
				for (var i = 0, size_i = array_length(available_movement_directions); i < size_i; i++) {
					var movement_direction		= available_movement_directions[i];
					var square_move_to/*:Square*/	= _square_move_from.get_neighbour(movement_direction);
					if (square_move_to != undefined && !square_move_to.is_has_piece()) {
						_turn_collection.push_turn(new Turn(player, _square_move_from, square_move_to));
					}
				}
			} else {
				var available_movement_directions/*:array<DIRECTION>*/ = [DIRECTION.NW, DIRECTION.NE, DIRECTION.SW, DIRECTION.SE];
				for (var i = 0, size_i = array_length(available_movement_directions); i < size_i; i++) {
					var movement_direction	= available_movement_directions[i];
					var square_move_from	= _square_move_from;
					while (square_move_from != undefined) {
						var square_move_to/*:Square*/	= square_move_from.get_neighbour(movement_direction);
						if (square_move_to != undefined && !square_move_to.is_has_piece()) {
							_turn_collection.push_turn(new Turn(player, _square_move_from, square_move_to));
						} else {
							break;
						}
						square_move_from = square_move_to;
					}
				}
			}
		}
	}
	
	static get_width = function()/*->number*/ {
		return __width;
	}
	
	static get_height = function()/*->number*/ {
		return __height;
	}
	
	static get_square = function(_x/*:number*/, _y/*:number*/)/*->Square*/ {
		return __squares[_x][_y];
	}
}