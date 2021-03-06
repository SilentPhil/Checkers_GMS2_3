function Square(_board/*:Board*/, _x/*:number*/, _y/*:number*/, _color/*:int<SQUARE_COLOR>*/) constructor {
	__board 		= _board;				/// @is {Board}
	__position		= new Point(_x, _y);	/// @is {Point}
	__color 		= _color;				/// @is {int<SQUARE_COLOR>}
	__piece 		= undefined;			/// @is {Piece?}
	__neighbours	= /*#cast*/ array_create(DIRECTION.SIZEOF, undefined); /// @is {Square?[]}
	
	static set_piece = function(_piece/*:Piece*/)/*->void*/ {
		__piece = _piece;
	}
	
	static reset_piece = function()/*->void*/ {
		__piece = undefined;
	}
	
	static set_neighbour = function(_direction/*:int<DIRECTION>*/, _other_square/*:Square*/)/*->void*/ {
		__neighbours[@ _direction] = _other_square;
	}
	
	#region getters
	static is_black = function()/*->bool*/ {
		return (__color == SQUARE_COLOR.BLACK);
	}
	
	static get_color = function()/*->int<SQUARE_COLOR>*/ {
		return __color;
	}
	
	/// @desc Возвращает, является ли клетка для указанного игрока краем доски, на котором шашка становится королевой
	static is_king_row = function(_player/*:Player*/)/*->bool*/ {
		switch (_player.get_side()) {
			case PLAYER_SIDE.BOTTOM:
				return (__position.y == 0);
			break;
			
			case PLAYER_SIDE.TOP:
				return (__position.y == (__board.get_height() - 1));
			break;
			
			default:
				return false;
			break;
		}
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
	
	/// @desc Возвращает соседнюю черную клетку в указанном направлении. 
	/// @desc Дистанция определяет, какой сосед будет браться - ближайший (если 1) или последующие (если > 1)
	static get_neighbour = function(_side/*:int<DIRECTION>*/, _distance/*:number*/ = 1)/*->Square?*/ {
		if (_distance == 1) {
			return __neighbours[_side];
		} else {
			var neighbour/*:Square*/ = __neighbours[_side];
			if (neighbour != undefined) {
				repeat (_distance - 1) {
					neighbour = neighbour.get_neighbour(_side);
					if (neighbour == undefined) {
						return undefined;
					}
				}
				return neighbour;
			} else {
				return undefined;
			}
		}
	}
	
	static get_x_notation = function()/*->string*/ {
		var unicode_small_eng_a = 97;
		return string(chr(unicode_small_eng_a + __position.x));
	}
	
	static get_y_notation = function()/*->string*/ {
		return string(__board.get_height() - __position.y);
	}
	
	static toString = function()/*->string*/ {
		return string(__position);
	}
	#endregion
}

enum SQUARE_COLOR {
	BLACK,
	WHITE
}