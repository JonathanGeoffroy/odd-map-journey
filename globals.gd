extends Node

signal on_tile_added(value: TileValue, index: int)
signal on_tile_removed(value: TileValue, index: int)

@export var grid: Array[Slot] = []
@export var slot_size: int = 128

@export var deck: Array[TileValue] = []


func initialize() -> void:
	grid = []
	grid.resize(20)

	deck = []
	for i in range(0, 9):
		deck.push_back(TileValue.generate())
		on_tile_added.emit(deck[i], i)


func set_slot_size(size: int) -> void:
	slot_size = size
