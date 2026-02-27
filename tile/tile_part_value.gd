extends Node
class_name TilePartValue

var tile_value: TileValue
var road: TileValue.TileRoad


static func from_tile_value(tile_value: TileValue) -> TilePartValue:
	var part = TilePartValue.new()
	part.tile_value = tile_value

	var rand = randi_range(0, 3)
	var road_selected = false
	while !road_selected:
		if (tile_value.roads[rand]) == true:
			part.road = rand
			road_selected = true
		else:
			rand = (rand + 1) % 4

	return part
