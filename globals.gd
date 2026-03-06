extends Node

var TileScene = preload("res://tile/Tile.tscn")
signal on_selection_change(value: TileValue)
signal on_tile_added(value: TileValue, index: int)
signal on_tile_played(value: Tile, slotIndex: int)
signal on_tile_removed(value: TileValue, index: int)
signal on_slot_clicked(slotIndex: int)
signal on_slot_hover_change(value: TileValue, index: int)

@export var NB_COLUMNS := 5
@export var NB_ROWS := 5
@export var grid: Array[TileValue]
@export var slot_size: int = 128
@export var slot_hover = null

@export var deck: Array[TileValue] = []

@export var player: PlayerValue

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

	player = PlayerValue.new()
	var tile_index = NB_ROWS * NB_COLUMNS / 2
	var path = PathPart.new(tile_index, tile.value, tile.value.random_available_road())
	player.move_to(path)

	on_tile_played.emit(tile, tile_index)


func set_slot_size(size: int) -> void:
	slot_size = size


func set_selection(value: TileValue):
	selected_tile = value
	on_selection_change.emit(selected_tile)


func set_slot_hover(index):
	if slot_hover != index:
		slot_hover = index
		on_slot_hover_change.emit(index)


func get_board() -> Board:
	var board = get_node("/root/Game/Board")
	return board
