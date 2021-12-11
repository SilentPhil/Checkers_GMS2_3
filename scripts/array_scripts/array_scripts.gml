/// @template T
/// @arg {array<T>} arr
/// @arg {T} value
/// @returns {number} index
function array_find_index(arr, value) {
	for (var i = 0; i < array_length(arr); i++) {
		if (arr[i] == value) {
			return i;	
		}
	}
	return -1;
}

/// @arg ds_list
/// @arg [is_delete_list=false]
function array_from_list() {
	var list		= argument[0];
	var is_delete	= argument_count > 1 ? argument[1] : false;

	var size		= ds_list_size(list);
	var arr			= array_create(size);
	for (var i = 0; i < size; i++) {
		arr[i] = list[| i];	
	}

	if (is_delete) {
		ds_list_destroy(list);	
	}

	return arr;
}

/// @arg ds_priority
/// @arg [is_ascending=false]
/// @arg [is_delete_priority=false]
function array_from_priority() {
	var queue			= argument[0];
	var is_ascending	= argument_count > 1 ? argument[1] : false;
	var is_delete		= argument_count > 2 ? argument[2] : false;

	var size		= ds_priority_size(queue);
	var arr			= array_create(size);
	for (var i = 0; i < size; i++) {
		arr[i] = (is_ascending ? ds_priority_delete_min(queue) : ds_priority_delete_max(queue));	
	}

	if (is_delete) {
		ds_priority_destroy(queue);	
	}

	return arr;
}

/// @template T
/// @arg {array<T>} arr
/// @returns {T?} random_element
function array_get_random(argument0) {
	var arr = argument0;
	var len	= array_length(arr);

	if (len == 0) {
		return undefined;	
	} else {
		return arr[irandom(len - 1)];
	}
}

/// @template T
/// @arg {array<T>} arr_1
/// @arg {array<T>} arr_2
/// @returns {array<T>} arr_3
function array_join(argument0, argument1) {
	for (var i=0, size1 = array_length(argument0), size2 = array_length(argument1)-1; i<=size2; i++;) {
		argument0[size1+i]=argument1[i];
	}
	return argument0;
}

/// @template T
/// @arg {array<T>} arr_1
/// @arg {array<T>} arr_2
/// @arg {array<T>} [...arr_n]
/// @returns {array<T>} arr_3
function array_merge() {
	var final_arr = [];
	
	for (var i = 0; i < argument_count; i++) {
		array_copy(final_arr, array_length(final_arr), argument[i], 0, array_length(argument[i]));
	}

	return final_arr;
}

/// @template T
/// @arg {array<T>} arr
function array_reverse(argument0)/*->array<T>*/ {
	var arr = argument0;

	var length		= array_length(arr);
	var half_length	= floor(length / 2);
	for (var i = 0; i < half_length; i++) {
		var temp	= arr[i];
		arr[@ i]	= arr[length - 1 - i];
		arr[@ length - 1 - i] = temp;
	}

	return arr;
}

/// @template T
/// @arg {array<T>} arr
function array_shuffle(arr/*:array<T>*/)/*->array<T>*/ {
	var new_array = array_clone(arr);
	
	var currentIndex = array_length(new_array);
	var temporaryValue, randomIndex;

	while (currentIndex != 0) {
		randomIndex = irandom(currentIndex - 1);
		currentIndex--;

		temporaryValue				= new_array[currentIndex];
		new_array[@ currentIndex]	= new_array[randomIndex];
		new_array[@ randomIndex]	= temporaryValue;
	}
	return new_array;
}

/// @template T
/// @arg {array<T>} arr
/// @arg func
function array_sort_func(arr, func)/*->void*/ {
	var len = array_length(arr);
	for (var i = 0, size_i = len - 1; i < size_i; i++) {
		for (var j = 0, size_j = len - i - 1; j < size_j; j++) {
			if (func(arr[j], arr[j + 1])) {
				var tmp = arr[j];
				arr[@ j] = arr[j + 1];
				arr[@ j + 1] = tmp;
			}
		}
	}
}

/// @template T
/// @arg {array<T>} arr
/// @arg {number?} [start]
/// @arg {number?} [stop]
/// @returns {array<T>} new_arr
function array_slice(arr, start, stop) {
	var arr_size	= array_length(arr);
	start		= is_undefined(start) ? 0			: clamp(start, 0, arr_size);
	stop		= is_undefined(stop) ? arr_size - 1	: clamp(stop, 0, arr_size - 1);
	var new_arr = [];

	for (var i = start, j = 0; i <= stop; i++) {
		new_arr[j++] = arr[i];
	}
	
	return new_arr;
}

/// @template T
/// @arg {array<T>} arr
/// @arg {T} value
/// @returns {bool} is_can_push
function array_push_unique(arr, value) {
	if (array_find_index(arr, value) == -1) {
		array_push(arr, value);
		return true;
	}
	return false;
}

/// @template T
/// @arg {array<T>} arr
/// @returns {bool} is_empty
function array_is_empty(arr) {
	return (array_length(arr) == 0);
}

/// @template T
/// @arg {array<T>} arr
/// @arg {number} index
/// @returns {bool} is_in_bounds
function array_index_in_bounds(arr, index) {
	var array_len = array_length(arr);
	if (array_len > 0) {
		return (index < array_len);
	} else {
		return false;
	}
}

/// @template T
/// @arg {array<T>} arr
/// @returns {T?} last_element
function array_get_last_element(arr) {
	var array_len = array_length(arr);
	if (array_len > 0) {
		return arr[array_len - 1];
	} else {
		return undefined;
	}
}

/// @template T
/// @arg {array<T>} arr
/// @returns {T?} first_element
function array_get_first_element(arr) {
	var array_len = array_length(arr);
	if (array_len > 0) {
		return arr[0];
	} else {
		return undefined;
	}
}

/// @template T
/// @arg {array<T>} arr
/// @arg {T} value
/// @returns {bool} is_was_deleted
function array_delete_by_value(arr, val) {
	var val_index = array_find_index(arr, val);
	if (val_index != -1) {
		array_delete(arr, val_index, 1);
		return true;
	} else {
		return false;
	}
}

/// @template T
/// @arg {array<T>} arr
/// @returns {array<T>} cloned_array
function array_clone(arr) {
	var new_arr = [];
	array_copy(new_arr, 0, arr, 0, array_length(arr));
	return new_arr;
}

/// @arg {array} arr
function array_to_string(arr)/*->string*/ {
	var str = "";
	for (var i = 0, size_i = array_length(arr); i < size_i; i++) {
		str += arr[i] + (i < size_i - 1 ? ", " : "");
	}
	return str;
}

/// @template T
/// @arg {array<T>} arr
/// @arg {number} index_1
/// @arg {number} index_2
/// @returns {array<T>} arr
function array_swap_elements(_arr, _index_1, _index_2) {
	var size = array_length(_arr);
	if (_index_2 >= size) {
		_index_2 = 0;
	} else if (_index_2 < 0) {
		_index_2 = size - 1;
	}
	log("swap", _index_1, _index_2);
	var tmp = _arr[_index_1];
	_arr[@ _index_1] = _arr[_index_2];
	_arr[@ _index_2] = tmp;
}