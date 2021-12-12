function TurnHistory() constructor {
	__array_of_turns = [];	/// @is {Turn[]}
	
	static push_turn = function(_turn/*:Turn*/)/*->void*/ {
		array_push(__array_of_turns, _turn);
	}
	
	static delete_last_turn = function()/*->void*/ {
		if (!array_is_empty(__array_of_turns)) {
			array_delete(__array_of_turns, array_length(__array_of_turns) - 1, 1);
		}
	}
	
	static clear = function()/*->void*/ {
		__array_of_turns = [];
	}

	#region getters
	static get_last_turn = function()/*->Turn?*/ {
		return array_get_last_element(__array_of_turns);
	}
	#endregion
		
	/*
		На деле ход, после которого ты опять должен рубить, в истории считается за один ход с предыдущими
		Это можно сделать на базе класса истории, не меняя основы класса Turn
	*/
}