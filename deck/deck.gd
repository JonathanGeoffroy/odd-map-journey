extends Node2D

const TileScene = preload("res://tile/Tile.tscn")

@export var margin := 8


func _ready() -> void:
	Globals.on_tile_added.connect(on_tile_added)
	Globals.on_tile_removed.connect(on_tile_removed)
	Globals.on_slot_clicked.connect(on_play_selection)


func on_tile_removed(tileValue: TileValue, index: int) -> void:
	var to_remove: Tile = get_child(index)
	assert(to_remove.value == tileValue, "wrong tile to delete from deck")
	remove_child(to_remove)


func on_tile_added(tileValue: TileValue, index: int) -> void:
	var to_add: Tile = TileScene.instantiate()
	to_add.value = tileValue
	to_add.position.y = (Globals.slot_size + margin) * index

	add_child(to_add)

	var i = 0
	for child in get_children():
		if child.is_in_group("Tile"):
			var tile: Tile = child
			if i >= index:
				tile.position.y += Globals.slot_size

			i += 1


func on_play_selection(grid_index: int) -> void:
	if Globals.selected_tile == null:
		return

	var children = get_children()
	var selected_tile_index = children.find_custom(
		func(child):
			print(child.is_in_group("Tile"))
			return child.is_in_group("Tile") and (child as Tile).value == Globals.selected_tile
	)
	assert(selected_tile_index >= 0, "tile to play not found")

	var selected_tile: Tile = children.get(selected_tile_index)
	on_tile_removed(selected_tile.value, selected_tile_index)

	Globals.set_selection(null)
	Globals.on_tile_played.emit(selected_tile, grid_index)


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				var global_position = get_global_mouse_position()
				for child in get_children():
					if child.is_in_group("Tile"):
						var tile: Tile = child
						var rect = Rect2(
							tile.global_position.x,
							tile.global_position.y,
							Globals.slot_size,
							Globals.slot_size
						)
						if rect.has_point(global_position):
							Globals.set_selection(
								tile.value if tile.value != Globals.selected_tile else null
							)
