/*
Классы:
	Доска - Клетки
		Клетка - цвет, ссылка на шашку
	Шашка - тип шашки (дама или нет), игрок - владелец шашки
	Ход - хранит в себе игрока, который ходит, шашку и движение откуда-куда
	История - хранит в себе ходы
	Контроллер игры - обрабатывает события игры
	Игрок - делает текущий ход
	Рендер - рисует графику
	
	
	Шашка знает клетку, где она находится?
	
	Мозги игрока:
		Можно выбрать клетку, если на ней шашка игрока, то нужно посчитать возможные ходы (и отобразить их)
		Можно кликнуть на другую клетку, если она входит в список доступных клеток, то этот ход отправляется на выполнение

*/

enum SQUARE_COLOR {
	BLACK,
	WHITE
}

enum PIECE_COLOR {
	BLACK,
	WHITE
}

enum SQUARE_NEIGHBOUR {
	NW,	// северо-запад - слева-сверху
	NE, // северо-восток - справа-сверху
	SE,	// юго-восток - справа-снизу
	SW, // юго-запад - слева-снизу
	
	SIZEOF
}

enum PLAYER_SIDE {
	TOP,
	BOTTOM
}

function Point(_x/*:number*/, _y/*:number*/) constructor {
	x = _x;
	y = _y;
}

function log()/*->void*/ {
	var str = "";
	for (var i = 0; i < argument_count; i++) {
		str += string(argument[i]) + ":";
	}
	show_debug_message(str);
}


/// @template T
function array_get_safe(_array/*:array<T>*/, _index/*:number*/)/*->T?*/ {
	if (_index >= 0 && _index < (array_length(_array) - 1)) {
		return _array[_index];
	} else {
		return undefined;
	}
}

/// @template T
function array_get_2d_safe(_array/*:T[][]*/, _i/*:number*/, _j/*:number*/)/*->T?*/ {
	if ((_i >= 0 && _i < (array_length(_array) - 1)) && (_j >= 0 && _j < (array_length(_array[_i]) - 1))) {
		return _array[_i][_j];
	} else {
		return undefined;
	}
}