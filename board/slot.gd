extends Node2D
class_name Slot


func _ready() -> void:
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	print("draw", Rect2(0, 0, Globals.slot_size, Globals.slot_size))
	draw_rect(Rect2(0, 0, Globals.slot_size, Globals.slot_size), Color.BLACK, false, 1)
