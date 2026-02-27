extends Node
class_name PlayerValue

signal on_player_moved(part: TilePartValue)

var current_part: TilePartValue
var next_part: TilePartValue


func move_to(part: TilePartValue) -> void:
	current_part = part
	on_player_moved.emit(current_part)
