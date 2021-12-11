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
	
	static get_turn_by_square_to = function(_square_to/*:Square*/)/*->Turn?*/ {
		for (var i = 0, size_i = array_length(__array_of_turns); i < size_i; i++) {
			if (__array_of_turns[i].get_square_to() == _square_to) {
				return __array_of_turns[i];
			}
		}
		return undefined;
	}
	
	static get_array_of_turns = function()/*->Turn[]*/ {
		return __array_of_turns;
	}
}

function TurnHistory() constructor {
	// __game = _game; 		/// @is {GameController}
	__array_of_turns = [];	/// @is {Turn[]}
	
	static push_turn = function(_turn/*:Turn*/)/*->void*/ {
		array_push(__array_of_turns, _turn);
	}
	
	static get_last_turn = function()/*->Turn?*/ {
		return array_get_last_element(__array_of_turns);
	}
	
	static delete_last_turn = function()/*->void*/ {
		if (!array_is_empty(__array_of_turns)) {
			array_delete(__array_of_turns, array_length(__array_of_turns) - 1, 1);
		}
	}
}