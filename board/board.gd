extends Node2D
class_name Board

var NB_COLUMNS := Globals.NB_COLUMNS
var NB_ROWS := Globals.NB_ROWS

var SlotScene := preload("res://board/slot.tscn")

@onready var boardChecker := BoardChecker.new()
@onready var boardPath := BoardPath.new()


func _ready() -> void:
	Globals.on_tile_played.connect(on_play_tile)
	Globals.on_slot_hover_change.connect(on_slot_hover_changed)
	Globals.on_selection_change.connect(on_selection_changed)

	for i in range(0, NB_ROWS * NB_COLUMNS):
		var slot: Slot = SlotScene.instantiate()
		var x := Globals.slot_size * (i % NB_COLUMNS)
		var y := Globals.slot_size * (i / NB_COLUMNS)

		slot.position = Vector2(x, y)
		add_child(slot)

	Globals.initialize()
	%Player.initialize(Globals.player)


func _process(delta: float) -> void:
	if Globals.selected_tile != null and is_mouse_inside():
		var slot_index = find_slot_index_at(get_global_mouse_position())
		if Globals.slot_hover != slot_index:
			Globals.set_slot_hover(slot_index if slot_index > -1 else null)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if !Globals.selected_tile or !is_mouse_inside():
					return

				var slot_index = find_slot_index_at(get_global_mouse_position())
				if boardChecker.can_add_tile_at(Globals.selected_tile, slot_index):
					Globals.on_slot_clicked.emit(slot_index)

			MOUSE_BUTTON_RIGHT:
				if !Globals.selected_tile:
					return
				Globals.selected_tile.rotate(1)
				Globals.set_selection(Globals.selected_tile)


func find_slot_index_at(mouse_position: Vector2) -> int:
	var local_position = mouse_position - position

	var row = int(local_position.x) / Globals.slot_size
	var col = int(local_position.y) / Globals.slot_size

	var result = col * NB_COLUMNS + row

	if result >= 0 and result < NB_ROWS * NB_COLUMNS:
		return result
	return -1


func is_mouse_inside() -> bool:
	var mouse_position = get_global_mouse_position()
	var local_position = mouse_position - position

	var rect = Rect2(
		local_position, Vector2(NB_COLUMNS * Globals.slot_size, NB_ROWS * Globals.slot_size)
	)
	return rect.has_point(local_position)


func on_play_tile(tile: Tile, gridIndex: int) -> void:
	Globals.grid[gridIndex] = tile.value
	var slot := find_slot_at(gridIndex)
	slot.add_child(tile)
	tile.position = Vector2(0, 0)


func on_slot_hover_changed(slot_index) -> void:
	compute_tile_state(slot_index)

	if slot_index != null:
		var best_path = (
			boardPath
			. find_best_path(
				Globals.grid,
				Globals.player.current_part,
			)
		)


func on_selection_changed(tileValue: TileValue) -> void:
	compute_tile_state(Globals.slot_hover)


func compute_tile_state(slot_index) -> void:
	if Globals.selected_tile != null:
		Globals.selected_tile.errored = (
			slot_index != null and !boardChecker.can_add_tile_at(Globals.selected_tile, slot_index)
		)


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


func find_slot(tileValue: TileValue) -> Slot:
	var index := Globals.grid.find(tileValue)
	return find_slot_at(index)
