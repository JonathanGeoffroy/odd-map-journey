extends Node2D

var NB_COLUMNS := 5
var NB_ROWS := 4

var SlotScene := preload("res://board/slot.tscn")

var slots: Array[TileValue]


func _ready() -> void:
	Globals.initialize()
	Globals.on_tile_played.connect(on_play_tile)

	slots = []
	slots.resize(20)

	for i in range(0, NB_ROWS * NB_COLUMNS):
		var slot: Slot = SlotScene.instantiate()
		var x := Globals.slot_size * (i % NB_COLUMNS)
		var y := Globals.slot_size * (i / NB_COLUMNS)

		slot.position = Vector2(x, y)
		add_child(slot)


func _process(delta: float) -> void:
	if Globals.selected_tile != null and is_mouse_inside():
		print(get_global_mouse_position())
		Globals.selected_tile.errored = !can_add_tile_at(
			Globals.selected_tile, get_global_mouse_position()
		)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if !Globals.selected_tile or !is_mouse_inside():
					return

				var slot_index = find_slot_index_at(get_global_mouse_position())
				Globals.on_slot_clicked.emit(slot_index)
				print("PLAY AT", slot_index)


func find_slot_index_at(mouse_position: Vector2) -> int:
	var local_position = mouse_position - position

	var row = int(local_position.x) / Globals.slot_size
	var col = int(local_position.y) / Globals.slot_size

	var result = col * NB_COLUMNS + row

	if result >= 0 or result < NB_ROWS * NB_COLUMNS:
		return result
	return -1


func is_mouse_inside() -> bool:
	var mouse_position = get_global_mouse_position()
	print(mouse_position)
	var local_position = mouse_position - position

	var rect = Rect2(
		local_position, Vector2(NB_COLUMNS * Globals.slot_size, NB_ROWS * Globals.slot_size)
	)
	return rect.has_point(local_position)


func can_add_tile_at(tile: TileValue, mouse_position: Vector2) -> bool:
	var slot_index = find_slot_index_at(mouse_position)

	if slot_index == -1:
		return false

	var tiles = find_sibling_tiles(slot_index)
	var tile_up: TileValue = tiles[0]
	var tile_right: TileValue = tiles[1]
	var tile_down: TileValue = tiles[2]
	var tile_left: TileValue = tiles[3]

	# tile must touch at least one other tile
	if tile_up == null && tile_down == null && tile_left == null && tile_right == null:
		return false

	var roads = tile.roads
	# All tiles must be valid with the new tile
	return (
		(
			tile_up == null
			|| tile_up.roads[TileValue.TileRoad.BOTTOM] == roads[TileValue.TileRoad.TOP]
		)
		and (
			tile_down == null
			|| tile_up.roads[TileValue.TileRoad.TOP] == roads[TileValue.TileRoad.BOTTOM]
		)
		and (
			tile_left == null
			|| tile_left.roads[TileValue.TileRoad.RIGHT] == roads[TileValue.TileRoad.LEFT]
		)
		and (
			tile_right == null
			|| tile_right.roads[TileValue.TileRoad.LEFT] == roads[TileValue.TileRoad.RIGHT]
		)
	)


func find_sibling_tiles(i: int) -> Array[TileValue]:
	var length = NB_COLUMNS * NB_ROWS
	var top: int = i - NB_COLUMNS if i >= NB_COLUMNS else length - (NB_COLUMNS - i)
	var bottom: int = i + NB_COLUMNS if i + NB_COLUMNS < length else (i + NB_COLUMNS) - length
	var left: int = i - 1 if i % NB_COLUMNS != 0 else i + NB_COLUMNS - 1
	var right: int = i + 1 if (i + 1) % NB_COLUMNS != 0 else i - NB_COLUMNS + 1

	return [slots[top], slots[right], slots[bottom], slots[left]]


func on_play_tile(tile: Tile, gridIndex: int) -> void:
	slots[gridIndex] = tile.value
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
