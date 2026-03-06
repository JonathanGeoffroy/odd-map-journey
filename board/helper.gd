extends Node

var NB_COLUMNS := Globals.NB_COLUMNS
var NB_ROWS := Globals.NB_ROWS
var LENGTH = NB_ROWS * NB_COLUMNS


func get_top(i: int) -> int:
	return i - NB_COLUMNS if i >= NB_COLUMNS else LENGTH - (NB_COLUMNS - i)


func get_right(i: int) -> int:
	return i + 1 if (i + 1) % NB_COLUMNS != 0 else i - NB_COLUMNS + 1


func get_bottom(i: int) -> int:
	return i + NB_COLUMNS if i + NB_COLUMNS < LENGTH else (i + NB_COLUMNS) - LENGTH


func get_left(i: int) -> int:
	return i - 1 if i % NB_COLUMNS != 0 else i + NB_COLUMNS - 1
