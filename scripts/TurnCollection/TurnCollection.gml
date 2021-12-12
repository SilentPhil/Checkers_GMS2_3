function TurnCollection() constructor {
	/// @todo Можно инкапсулировать пуш нового хода, создавая объект класса внутри push_turn
	__array_of_turns = []; /// @is {Turn[]}
	
	static push_turn = function(_turn/*:Turn*/)/*->void*/ {
		array_push(__array_of_turns, _turn);
	}
	
	#region getters
	static is_turn_exists = function(_square_to/*:Square*/)/*->bool*/ {
		for (var i = 0, size_i = array_length(__array_of_turns); i < size_i; i++) {
			if (__array_of_turns[i].get_square_to() == _square_to) {
				return true;
			}
		}
		return false;
	}
	
	static is_have_attack_turns = function()/*->bool*/ {
		for (var i = 0, size_i = array_length(__array_of_turns); i < size_i; i++) {
			if (__array_of_turns[i].is_attack()) {
				return true;
			}
		}
		return false;
	}
	
	static is_empty = function()/*->bool*/ {
		return array_is_empty(__array_of_turns);
	}
	
	static find_turn = function(_square_from/*:Square*/, _square_to/*:Square*/)/*->Turn?*/ {
		for (var i = 0, size_i = array_length(__array_of_turns); i < size_i; i++) {
			var turn = __array_of_turns[i];
			if (turn.get_square_from() == _square_from && turn.get_square_to() == _square_to) {
				return turn;
			}
		}
		return undefined;
	}
	
	static get_array_of_turns = function()/*->Turn[]*/ {
		return __array_of_turns;
	}
	
	static get_random = function()/*->Turn?*/ {
		return array_get_random(__array_of_turns);
	}
	#endregion
}