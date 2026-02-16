extends Node2D

const TileScene = preload("res://tile/Tile.tscn")

@export var margin := 8

var selected_tile: Tile = null


func _ready() -> void:
	Globals.on_tile_added.connect(on_tile_added)
	Globals.on_tile_removed.connect(on_tile_removed)


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
							if tile == selected_tile:
								tile.set_selected(false)
								selected_tile = null
							else:
								if selected_tile != null:
									selected_tile.set_selected(false)
								selected_tile = tile
								tile.set_selected(true)
