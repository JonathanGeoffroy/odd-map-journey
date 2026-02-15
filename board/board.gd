extends Node2D

var NB_COLUMNS := 5
var NB_ROWS := 4

var SlotScene := preload("res://board/slot.tscn")


func _ready() -> void:
	Globals.initialize()

	for i in range(0, 20):
		var slot: Slot = SlotScene.instantiate()
		var x := Globals.slot_size * (i % NB_COLUMNS)
		var y := Globals.slot_size * (i / NB_COLUMNS)
		slot.position = Vector2(x, y)
		add_child(slot)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
