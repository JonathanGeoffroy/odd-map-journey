extends Node
class_name PlayerValue

signal on_player_moved(part: PathPart)

var current_part: PathPart
var next_part: PathPart


func move_to(part: PathPart) -> void:
	current_part = part
	on_player_moved.emit(current_part)
