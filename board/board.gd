extends Node2D
class_name Board

var NB_COLUMNS := Globals.NB_COLUMNS
var NB_ROWS := Globals.NB_ROWS
var LENGTH = NB_ROWS * NB_COLUMNS

var SlotScene := preload("res://board/slot.tscn")


func _ready() -> void:
	Globals.on_tile_played.connect(on_play_tile)

	for i in range(0, NB_ROWS * NB_COLUMNS):
		var slot: Slot = SlotScene.instantiate()
		var x := Globals.slot_size * (i % NB_COLUMNS)
		var y := Globals.slot_size * (i / NB_COLUMNS)

		slot.position = Vector2(x, y)
		add_child(slot)

	Globals.initialize()


func _process(delta: float) -> void:
	if Globals.selected_tile != null and is_mouse_inside():
		var slot_index = find_slot_index_at(get_global_mouse_position())
		Globals.selected_tile.errored = !can_add_tile_at(Globals.selected_tile, slot_index)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				if !Globals.selected_tile or !is_mouse_inside():
					return

				var slot_index = find_slot_index_at(get_global_mouse_position())

				if can_add_tile_at(Globals.selected_tile, slot_index):
					Globals.on_slot_clicked.emit(slot_index)


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


func can_add_tile_at(tile: TileValue, slot_index: int) -> bool:
	if slot_index == -1 or Globals.grid[slot_index] != null:
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
			|| tile_down.roads[TileValue.TileRoad.TOP] == roads[TileValue.TileRoad.BOTTOM]
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
	assert(i >= 0 && i < LENGTH)

	var top: int = i - NB_COLUMNS if i >= NB_COLUMNS else LENGTH - (NB_COLUMNS - i)
	var bottom: int = i + NB_COLUMNS if i + NB_COLUMNS < LENGTH else (i + NB_COLUMNS) - LENGTH
	var left: int = i - 1 if i % NB_COLUMNS != 0 else i + NB_COLUMNS - 1
	var right: int = i + 1 if (i + 1) % NB_COLUMNS != 0 else i - NB_COLUMNS + 1

	var grid = Globals.grid
	return [grid[top], grid[right], grid[bottom], grid[left]]


func on_play_tile(tile: Tile, gridIndex: int) -> void:
	Globals.grid[gridIndex] = tile.value
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
