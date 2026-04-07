extends Node
class_name BoardPath


func find_best_path(grid: Array[TileValue], from: PathPart) -> Array[PathPart]:
	var result = compute_next(grid, from, [from])
	result.pop_front()
	return result


func compute_next(
	grid: Array[TileValue], path_part: PathPart, result: Array[PathPart]
) -> Array[PathPart]:
	var best_path = result.duplicate()
	var same_tile_accepted = (
		result.size() <= 1
		or result[result.size() - 1].grid_index != result[result.size() - 2].grid_index
	)

	for possibility in compute_possibilities(grid, path_part, result, same_tile_accepted):
		var next_result = result.duplicate()
		next_result.push_back(possibility)
		next_result = compute_next(grid, possibility, next_result)

		if next_result.size() > best_path.size():
			best_path = next_result

	return best_path


func compute_possibilities(
	grid: Array[TileValue], from: PathPart, exclusions: Array[PathPart], accept_same_tile: bool
) -> Array[PathPart]:
	if from.tile_value == null:
		return []

	var result: Array[PathPart] = []

	find_sibling(
		grid,
		from,
		BoardHelper.get_top(from.grid_index),
		TileValue.TileRoad.TOP,
		exclusions,
		accept_same_tile,
		result
	)
	find_sibling(
		grid,
		from,
		BoardHelper.get_bottom(from.grid_index),
		TileValue.TileRoad.BOTTOM,
		exclusions,
		accept_same_tile,
		result
	)
	find_sibling(
		grid,
		from,
		BoardHelper.get_left(from.grid_index),
		TileValue.TileRoad.LEFT,
		exclusions,
		accept_same_tile,
		result
	)
	find_sibling(
		grid,
		from,
		BoardHelper.get_right(from.grid_index),
		TileValue.TileRoad.RIGHT,
		exclusions,
		accept_same_tile,
		result
	)

	return result


func find_sibling(
	grid: Array[TileValue],
	from: PathPart,
	sibling: int,
	pivot: TileValue.TileRoad,
	exclusions: Array[PathPart],
	accept_same_tile: bool,
	array: Array[PathPart]
):
	var counter_pivot = (pivot + 2) % 4
	var index = sibling if from.road == pivot else from.grid_index
	var tile = grid[index]
	var road: TileValue.TileRoad = pivot if from.road == counter_pivot else counter_pivot

	if tile != null and tile.roads[road] == true and (accept_same_tile or index != from.grid_index):
		var path_part = PathPart.new(index, tile, road)
		if !is_excluded(exclusions, path_part):
			array.push_back(path_part)

	return array


func is_excluded(exclusions: Array[PathPart], pathPart: PathPart) -> bool:
	return exclusions.any(
		func(pp: PathPart): return pp.grid_index == pathPart.grid_index and pp.road == pathPart.road
	)
