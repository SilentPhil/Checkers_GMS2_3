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

function TurnCollection() constructor {
	/// @todo Можно инкапсулировать пуш нового хода, создавая объект класса внутри push_turn
	__array_of_turns = []; /// @is {Turn[]}
	
	static push_turn = function(_turn/*:Turn*/)/*->void*/ {
		array_push(__array_of_turns, _turn);
	}
	
	static is_turn_exists = function(_square_to/*:Square*/)/*->bool*/ {
		for (var i = 0, size_i = array_length(__array_of_turns); i < size_i; i++) {
			if (__array_of_turns[i].get_square_to() == _square_to) {
				return true;
			}
		}
		return false;
	}
	
	static get_array_of_turns = function()/*->Turn[]*/ {
		return __array_of_turns;
	}
}