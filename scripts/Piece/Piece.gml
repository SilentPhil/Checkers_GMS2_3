function Piece(_color/*:int<PIECE_COLOR>*/, _player/*:Player*/) constructor {
	__color 	= _color;	/// @is {int<PIECE_COLOR>}
	__player	= _player;	/// @is {Player}
	__is_king	= false;
	
	static is_king = function()/*->bool*/ {
		return __is_king;
	}
	
	static set_king = function(_is_king/*:bool*/)/*->void*/ {
		__is_king = _is_king;
	}
	
	static get_player = function()/*->Player*/ {
		return __player;
	}
	
	static get_color = function()/*->int<PIECE_COLOR>*/ {
		return __color;
	}	
	
	static get_available_movement_directions = function()/*->int<DIRECTION>[]*/ {
		var available_movement_neighbours/*:int<DIRECTION>[]*/ = [];
		
		if (__player.get_side() == PLAYER_SIDE.TOP) {
			return [DIRECTION.SE, DIRECTION.SW];
		} else {
			return [DIRECTION.NE, DIRECTION.NW];
		}
		
		return available_movement_neighbours;
	}
}

enum PIECE_COLOR {
	BLACK,
	WHITE
}