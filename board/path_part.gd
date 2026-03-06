extends Node
class_name PathPart

var grid_index: int
var tile_value: TileValue
var road: int


func _init(grid_index: int, tile_value: TileValue, road: TileValue.TileRoad):
	self.grid_index = grid_index
	self.tile_value = tile_value
	self.road = road
