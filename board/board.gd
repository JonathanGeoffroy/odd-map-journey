extends Node2D

var NB_COLUMNS := 5
var NB_ROWS := 4

var SlotScene := preload("res://board/slot.tscn")


func _ready() -> void:
	Globals.initialize()
	Globals.on_tile_played.connect(on_play_tile)

	for i in range(0, 20):
		var slot: Slot = SlotScene.instantiate()
		var x := Globals.slot_size * (i % NB_COLUMNS)
		var y := Globals.slot_size * (i / NB_COLUMNS)

		slot.position = Vector2(x, y)
		add_child(slot)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if !Globals.selected_tile or !is_clicked_inside():
					return

				var slot_index = find_slot_index_at(get_global_mouse_position())
				Globals.on_slot_clicked.emit(slot_index)
				print("PLAY AT", slot_index)


func find_slot_index_at(mouse_position: Vector2) -> int:
	var local_position = mouse_position - position

	var row = int(local_position.x) / Globals.slot_size
	var col = int(local_position.y) / Globals.slot_size
	return col * NB_COLUMNS + row


func is_clicked_inside() -> bool:
	var mouse_position = get_global_mouse_position()
	print(mouse_position)
	var local_position = mouse_position - position

	var rect = Rect2(
		local_position, Vector2(NB_COLUMNS * Globals.slot_size, NB_ROWS * Globals.slot_size)
	)
	return rect.has_point(local_position)


func on_play_tile(tile: Tile, gridIndex: int) -> void:
	var slot := find_slot_at(gridIndex)
	slot.add_child(tile)
	tile.position = Vector2(0, 0)


func find_slot_at(gridIndex: int) -> Slot:
	var i = 0
	for child in get_children():
		if child.is_in_group("Slot"):
			if i == gridIndex:
				return child as Slot
			else:
				i += 1
	assert(false, str("Slot not found at index", gridIndex))
	return null
