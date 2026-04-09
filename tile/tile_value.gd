extends Node
class_name TileValue

signal on_rotate(rotation: int)

enum TileKind { TOP_BOTTOM = 0, TOP_LEFT = 1, TOP_LEFT_RIGHT = 2, ALL = 3 }

enum TileRoad { TOP = 0, RIGHT = 1, BOTTOM = 2, LEFT = 3 }

@export var kind: TileKind
@export var roads: Array[bool] = [false, false, false, false]
@export var errored := false
@export var rotation := 0
@export var used_for: Array[int]


static func generate() -> TileValue:
	var nb_tiles := TileValue.TileKind.keys().size()
	var tile_kind_index := randi_range(0, nb_tiles - 1)

	return TileValue.new(tile_kind_index)


func _init(tile_kind: TileKind) -> void:
	kind = tile_kind
	roads = compute_road_by_kind(kind)
	used_for = [0, 0, 0, 0]


static func compute_road_by_kind(kind: TileKind) -> Array[bool]:
	match kind:
		TileKind.TOP_BOTTOM:
			return [true, false, true, false]
		TileKind.TOP_LEFT:
			return [true, false, false, true]
		TileKind.TOP_LEFT_RIGHT:
			return [true, true, false, true]
		TileKind.ALL:
			return [true, true, true, true]
		_:
			assert(false, str("Should handle TileKind ", kind))
			return [true, true, true, true]


func rotate(number: int) -> void:
	rotation = (rotation + number) % 4
	on_rotate.emit(rotation)


func random_available_road() -> TileRoad:
	var road: TileRoad
	var rand = randi_range(0, 3)
	var road_selected = false
	while !road_selected:
		if roads[rand] == true:
			road = rand
			road_selected = true
		else:
			rand = (rand + 1) % 4

	return road
