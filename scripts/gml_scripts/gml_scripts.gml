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

function draw_cross(_x/*:number*/, _y/*:number*/, _size/*:number*/, _width/*:number*/ = 1, _angle/*:number*/ = 0) {
	draw_line_width(_x - lengthdir_x(_size, _angle), _y - lengthdir_y(_size, _angle), _x + lengthdir_x(_size, _angle), _y + lengthdir_y(_size, _angle), _width);
	draw_line_width(_x - lengthdir_x(_size, _angle + 90), _y - lengthdir_y(_size, _angle + 90), _x + lengthdir_x(_size, _angle + 90), _y + lengthdir_y(_size, _angle + 90), _width);
}