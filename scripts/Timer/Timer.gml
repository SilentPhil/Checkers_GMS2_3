function Timer(_initial_duration/*:number*/) constructor {
	__initital_duration = _initial_duration;		/// @is {number}
	__timer 			= __initital_duration;		/// @is {number}
	
	static is_done = function()/*->bool*/ {
		if (__timer > 0) {
			__timer -= 1;
			if (__timer <= 0) {
				return true;
			}
		}
		return false;
	}
	
	static set = function(_duration/*:number*/)/*->void*/ {
		__timer = _duration;
	}
	
	static reset = function()/*->void*/ {
		__timer = __initital_duration;
	}
	
	static get = function()/*->number*/ {
		return __timer;
	}
	
	static get_initial_duration = function()/*->number*/ {
		return __initital_duration;
	}
	
	static force_done = function()/*->void*/ {
		__timer = 1;
	}
	
	static disable = function()/*->void*/ {
		__timer = noone;
	}
	
	static is_disabled = function()/*->bool*/ {
		return (__timer == noone);
	}
}