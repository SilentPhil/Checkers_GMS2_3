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