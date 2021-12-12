function Turn(_player/*:Player*/, _square_from/*:Square*/, _square_to/*:Square*/, _square_under_attack/*:Square?*/ = undefined) constructor {
	__player				= _player;						/// @is {Player}
	__square_from			= _square_from;					/// @is {Square}
	__square_to 			= _square_to;					/// @is {Square}
	__square_under_attack	= _square_under_attack;			/// @is {Square?}
	
	__piece 				= __square_from.get_piece();	/// @is {Piece}
	__piece_under_attack	= undefined;					/// @is {Piece?}
	if (__square_under_attack != undefined) {
		__piece_under_attack = __square_under_attack.get_piece();
	}
	__is_crowned_turn		= (!__piece.is_king() && __square_to.is_king_row(__player)); // Приведет ли этот ход к коронации пешки
	
	static get_player = function()/*->Player*/ {
		return __player;
	}
	
	static get_square_from = function()/*->Square*/ {
		return __square_from;
	}	
	
	static get_square_to = function()/*->Square*/ {
		return __square_to;
	}
	
	static get_square_under_attack = function()/*->Square?*/ {
		return __square_under_attack;
	}
	
	static get_piece = function()/*->Piece*/ {
		return __piece;
	}		
	
	static get_piece_under_attack = function()/*->Piece?*/ {
		return __piece_under_attack;
	}
	
	static is_crowned_turn = function()/*->bool*/ {
		return __is_crowned_turn;
	}
	
	static is_attack = function()/*->bool*/ {
		return (__square_under_attack != undefined); 
	}
	
	static toString = function()/*->string*/ {
		return (string(__square_from) + "->" + string(__square_to) + "|" + (is_attack() ? "A" : "M"));
	}
}