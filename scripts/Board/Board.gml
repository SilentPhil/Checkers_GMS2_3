function Board(_players/*:Player[]*/) constructor {
	__players	= _players;	/// @is {Player[]}
	__squares	= [];		/// @is {Square[][]}
	__width		= 8;
	__height	= 8;
	
	// Расстановка клеток
	for (var i = 0; i < __width; i++) {
		for (var j = 0; j < __height; j++) {
			var color = /*#cast*/ ((1 + i mod 2 + j mod 2) mod 2) /*#as SQUARE_COLOR*/;
			__squares[i][j] = new Square(i, j, color);
		}
	}
	
	// Определение соседей у клеток
	for (var i = 0; i < __width; i++) {
		for (var j = 0; j < __height; j++) {
			var square = __squares[i][j];
			square.__neighbours[@ SQUARE_NEIGHBOUR.NW] = array_get_2d_safe(__squares, i - 1, j - 1);
			square.__neighbours[@ SQUARE_NEIGHBOUR.NE] = array_get_2d_safe(__squares, i + 1, j - 1);
			square.__neighbours[@ SQUARE_NEIGHBOUR.SE] = array_get_2d_safe(__squares, i + 1, j + 1);
			square.__neighbours[@ SQUARE_NEIGHBOUR.SW] = array_get_2d_safe(__squares, i - 1, j + 1);
		}
	}
	
	// Расстановка шашек
	var pieces_lines_width = 3;
	for (var i = 0; i < __width; i++) {
		for (var j = 0; j < __height; j++) {
			var square = __squares[i][j];
			if (square.is_black()) {
				if (j < pieces_lines_width) {
					square.set_piece(new Piece(PIECE_COLOR.BLACK, __players[0]));
				} else if (j >= __height - pieces_lines_width) {
					square.set_piece(new Piece(PIECE_COLOR.WHITE, __players[1]));
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
	
	static get_available_turns = function(_square/*:Square*/)/*->TurnCollection*/ {
		var available_turns = new TurnCollection();
		
		if (_square.is_has_piece()) {
			var piece/*:Piece*/ 	= _square.get_piece();
			var piece_player	= piece.get_player();
			var available_movement_neighbours = piece.get_available_movement_neighbours();
			
			for (var i = 0, size_i = array_length(available_movement_neighbours); i < size_i; i++) {
				var movement_neighbour		= available_movement_neighbours[i];
				var neigbour_square/*:Square*/	= _square.get_neighbour(movement_neighbour);
				if (neigbour_square != undefined) {
					if (!neigbour_square.is_has_piece()) {
						available_turns.push_turn(new Turn(piece_player, _square, neigbour_square));
					} else if (neigbour_square.is_has_piece(get_other_player(piece_player))) {
						// В этом поле находится фишка врага, нужно посмотреть, можно ли ее перепрыгнуть в том же направлении
						var attack_neighbour_square/*:Square*/ = neigbour_square.get_neighbour(movement_neighbour);
						if (attack_neighbour_square != undefined) {
							if (!attack_neighbour_square.is_has_piece()) {
								available_turns.push_turn(new Turn(piece_player, _square, attack_neighbour_square, neigbour_square));
							}
						}
					}
				}
			}
		}
		
		return available_turns;
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
	
	/// @todo этот метод можно перенести в GameController
	static get_other_player = function(_player/*:Player*/)/*->Player*/ {
		return (_player == __players[0] ? __players[1] : __players[0]);
	}
}

function Square(_x/*:number*/, _y/*:number*/, _color/*:SQUARE_COLOR*/) constructor {
	__position		= new Point(_x, _y);	/// @is {Point}
	__color 		= _color;				/// @is {SQUARE_COLOR}
	__piece 		= undefined;			/// @is {Piece?}
	__neighbours	= /*#cast*/ array_create(SQUARE_NEIGHBOUR.SIZEOF, undefined); /// @is {Square?[]}
	
	static set_piece = function(_piece/*:Piece*/)/*->void*/ {
		__piece = _piece;
	}
	
	static reset_piece = function()/*->void*/ {
		__piece = undefined;
	}
	
	static is_black = function()/*->bool*/ {
		return (__color == SQUARE_COLOR.BLACK);
	}
	
	static get_color = function()/*->SQUARE_COLOR*/ {
		return __color;
	}
	
	static is_has_piece = function(_player/*:Player*/ = undefined)/*->bool*/ {
		if (_player == undefined) {
			return (__piece != undefined);
		} else if (__piece != undefined) {
			return ((__piece /*#as Piece*/).get_player() == _player);
		} else {
			return false;
		}
	}
	
	static get_piece = function()/*->Piece?*/ {
		return __piece;
	}
	
	static get_position = function()/*->Point*/ {
		return __position;
	}
	
	static get_neighbour = function(_side/*:SQUARE_NEIGHBOUR*/)/*->Square?*/ {
		return __neighbours[/*#cast*/ _side];
	}
}

function Piece(_color/*:PIECE_COLOR*/, _player/*:Player*/) constructor {
	__color 	= _color;	/// @is {PIECE_COLOR}
	__player	= _player;	/// @is {Player}
	__is_king	= false;
	
	static is_king = function()/*->bool*/ {
		return __is_king;
	}
	
	static get_player = function()/*->Player*/ {
		return __player;
	}
	
	static get_color = function()/*->PIECE_COLOR*/ {
		return __color;
	}	
	
	static get_available_movement_neighbours = function()/*->SQUARE_NEIGHBOUR[]*/ {
		var available_movement_neighbours/*:SQUARE_NEIGHBOUR[]*/ = [];
		
		if (__player.get_side() == PLAYER_SIDE.TOP) {
			return [SQUARE_NEIGHBOUR.SE, SQUARE_NEIGHBOUR.SW];
		} else {
			return [SQUARE_NEIGHBOUR.NE, SQUARE_NEIGHBOUR.NW];
		}
		
		return available_movement_neighbours;
	}
}