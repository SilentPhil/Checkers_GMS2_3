function Turn(_piece/*:Piece*/, _square_from/*:Square*/, _square_to/*:Square*/, _square_under_attack/*:Square?*/ = undefined) constructor {
	__piece 				= _piece;				/// @is {Piece}
	__square_from			= _square_from;			/// @is {Square}
	__square_to 			= _square_to;			/// @is {Square}
	__square_under_attack	= _square_under_attack;	/// @is {Square}
	
	static get_piece = function()/*->Piece*/ {
		return __piece;
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
	
	static is_attack = function()/*->bool*/ {
		return (__square_under_attack != undefined); 
	}
	
	/*
		Шашка, которая ходит
		Клетка, откуда производится ход
		Клетка, куда производится ход
		Клетка под ударом (или undefined)
	*/
}