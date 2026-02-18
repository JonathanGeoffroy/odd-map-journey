extends Node2D
class_name Slot


func _draw() -> void:
	draw_rect(Rect2(0, 0, Globals.slot_size, Globals.slot_size), Color.BLACK, false, 1)


func on_mouse_entered() -> void:
	pass
