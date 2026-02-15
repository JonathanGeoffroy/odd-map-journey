extends Node2D

const TileScene = preload("res://tile/Tile.tscn")

@export var margin := 8


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
