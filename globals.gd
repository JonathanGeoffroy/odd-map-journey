extends Node

var TileScene = preload("res://tile/Tile.tscn")
signal on_selection_change(value: TileValue)
signal on_tile_added(value: TileValue, index: int)
signal on_tile_played(value: Tile, slotIndex: int)
signal on_tile_removed(value: TileValue, index: int)
signal on_slot_clicked(slotIndex: int)

@export var NB_COLUMNS := 5
@export var NB_ROWS := 4
@export var grid: Array[TileValue]
@export var slot_size: int = 128

@export var deck: Array[TileValue] = []

var selected_tile: TileValue = null


func initialize() -> void:
	grid = []
	grid.resize(NB_COLUMNS * NB_ROWS)

	deck = []
	for i in range(0, 9):
		deck.push_back(TileValue.generate())
		on_tile_added.emit(deck[i], i)

	var tile = TileScene.instantiate()
	tile.value = TileValue.generate()
	on_tile_played.emit(tile, 8)


func set_slot_size(size: int) -> void:
	slot_size = size


func set_selection(value: TileValue):
	selected_tile = value
	on_selection_change.emit(value)
