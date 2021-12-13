function Board(_game/*:GameController*/) constructor {
	__game		= _game;				/// @is {GameController}
	__players	= __game.get_players();	/// @is {Player[]}
	__squares	= [];					/// @is {Square[][]}
	__width		= 8;
	__height	= 8;
	
	// Расстановка клеток
	for (var i = 0; i < __width; i++) {
		for (var j = 0; j < __height; j++) {
			var color = ((1 + i mod 2 + j mod 2) mod 2) /*#as int<SQUARE_COLOR>*/;
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
		var piece/*:Piece*/ = _old_square.get_piece();
		_old_square.reset_piece();
		_new_square.set_piece(piece);
	}
	
	static delete_piece = function(_square/*:Square*/)/*->void*/ {
		_square.reset_piece();
	}
	
	/// @desc Заполняет переданную коллекцию ходов возможными ходами атак с указанной клетки
	static __fill_turns_collection_with_available_attack = function(_turn_collection/*:TurnCollection*/, _square_attack_from/*:Square*/)/*->void*/ {
		if (_square_attack_from.is_has_piece()) {
			var piece/*:Piece*/ = _square_attack_from.get_piece();
			var player		= piece.get_player();
					
			var available_attack_directions/*:int<DIRECTION>[]*/ = [DIRECTION.NW, DIRECTION.NE, DIRECTION.SW, DIRECTION.SE];
			if (piece.is_king()) {
				var attack_max_distance = max(get_width(), get_height());
			} else {
				var attack_max_distance = 1;
			}
			
			
			
			for (var i = 0, size_i = array_length(available_attack_directions); i < size_i; i++) {
				var attack_direction = available_attack_directions[i];
				for (var j = 1; j <= attack_max_distance; j++) {
					var square_under_attack/*:Square*/	= _square_attack_from.get_neighbour(attack_direction, j);
					// Найдена клетка с шашкой врага
					if (square_under_attack != undefined && square_under_attack.is_has_piece(__game.get_other_player_for(player))) {
						// Ищим свободные клетки за шашкой врага
						
						/// @todo Если среди этих клеток будет хоть одна, с которой можно атаковать в перпендикулярные текущему направлению стороны,
						/// то среди возможных ходов должны быть только клетки с возможностью атаки
						
						for (var k = 1; k <= attack_max_distance; k++) {
							var square_attack_to/*:Square*/ = square_under_attack.get_neighbour(attack_direction, k);
							if (square_attack_to != undefined && !square_attack_to.is_has_piece()) {
								_turn_collection.push_turn(new Turn(player, _square_attack_from, square_attack_to, square_under_attack));
							} else {
								// Если достигли конца доски или встретили хоть одну шашку, то дальше свободные клетки не ищим
								break;
							}
						}
						// Т.к. шашку врага уже нашли - в этом направлении дальше искать врагов смысла нет
						break;
					}
				}
			}
		}
	}
	
	/// @desc Заполняет переданную коллекцию ходов возможными ходами движения с указанной клетки
	static __fill_turns_collection_with_available_move = function(_turn_collection/*:TurnCollection*/, _square_move_from/*:Square*/)/*->void*/ {
		if (_square_move_from.is_has_piece()) {
			var piece/*:Piece*/ = _square_move_from.get_piece();
			var player		= piece.get_player();
			
			if (piece.is_king()) {
				var available_movement_directions/*:int<DIRECTION>[]*/ = [DIRECTION.NW, DIRECTION.NE, DIRECTION.SW, DIRECTION.SE];
				var move_max_distance = max(get_width(), get_height());
			} else {
				var available_movement_directions/*:int<DIRECTION>[]*/ = piece.get_available_movement_directions();
				var move_max_distance = 1;
			}
			
			for (var i = 0, size_i = array_length(available_movement_directions); i < size_i; i++) {
				var movement_direction	= available_movement_directions[i];
				for (var j = 1; j <= move_max_distance; j++) {
					var square_move_to/*:Square*/ = _square_move_from.get_neighbour(movement_direction, j);
					if (square_move_to != undefined && !square_move_to.is_has_piece()) {
						_turn_collection.push_turn(new Turn(player, _square_move_from, square_move_to));
					} else {
						break;
					}
				}
			}
		}
	}
		
	#region getters
	static get_available_turns = function(_player/*:Player*/, _square_from/*:Square*/ = undefined)/*->TurnCollection*/ {
		var available_turns 		= new TurnCollection();
		
		// Ходить можно либо всеми шашками, либо конкретной
		var array_of_pieces_squares = (_square_from == undefined ? get_array_of_pieces_squares_for_player(_player) : [_square_from]);
		
		for (var i = 0, size_i = array_length(array_of_pieces_squares); i < size_i; i++) {
			__fill_turns_collection_with_available_attack(available_turns, array_of_pieces_squares[i]);
		}		
		
		// Ходить можно только если нет возможности атаковать
		if (available_turns.is_empty()) {
			for (var i = 0, size_i = array_length(array_of_pieces_squares); i < size_i; i++) {
				__fill_turns_collection_with_available_move(available_turns, array_of_pieces_squares[i]);
			}
		}
		
		return available_turns;
	}

	static get_array_of_pieces_squares_for_player = function(_player/*:Player*/)/*->Square[]*/ {
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
	
	static get_width = function()/*->number*/ {
		return __width;
	}
	
	static get_height = function()/*->number*/ {
		return __height;
	}
	
	static get_square = function(_x/*:number*/, _y/*:number*/)/*->Square*/ {
		return __squares[_x][_y];
	}
	#endregion
}

enum DIRECTION {
	NW,	// северо-запад - слева-сверху
	NE, // северо-восток - справа-сверху
	SE,	// юго-восток - справа-снизу
	SW, // юго-запад - слева-снизу
	
	SIZEOF
}