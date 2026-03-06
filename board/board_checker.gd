extends Node
class_name BoardChecker

var NB_COLUMNS := Globals.NB_COLUMNS
var NB_ROWS := Globals.NB_ROWS
var LENGTH = NB_ROWS * NB_COLUMNS


func road_at(tile: TileValue, roadIndex: TileValue.TileRoad) -> bool:
	return tile.roads[(roadIndex + 4 - tile.rotation) % 4]


func can_add_tile_at(tile: TileValue, slot_index: int) -> bool:
	if slot_index == -1 or Globals.grid[slot_index] != null:
		return false

	var tiles = find_sibling_tiles(slot_index)
	var tile_up: TileValue = tiles[0]
	var tile_right: TileValue = tiles[1]
	var tile_down: TileValue = tiles[2]
	var tile_left: TileValue = tiles[3]

	# tile must touch at least one other tile
	if tile_up == null && tile_down == null && tile_left == null && tile_right == null:
		return false

	var roads = tile.roads

	var up = null if tile_up == null else road_at(tile_up, TileValue.TileRoad.BOTTOM)
	var bottom = null if tile_down == null else road_at(tile_down, TileValue.TileRoad.TOP)
	var left = null if tile_left == null else road_at(tile_left, TileValue.TileRoad.RIGHT)
	var right = null if tile_right == null else road_at(tile_right, TileValue.TileRoad.LEFT)

	# Tile should connect at least one road
	if !(up or bottom or left or right):
		return false

	# All tiles must be valid with the new tile
	return (
		(tile_up == null || up == road_at(tile, TileValue.TileRoad.TOP))
		and (tile_down == null || (bottom == road_at(tile, TileValue.TileRoad.BOTTOM)))
		and (tile_left == null || (left == road_at(tile, TileValue.TileRoad.LEFT)))
		and (tile_right == null || (right == road_at(tile, TileValue.TileRoad.RIGHT)))
	)


func find_sibling_tiles(i: int) -> Array[TileValue]:
	assert(i >= 0 && i < LENGTH)

	var top: int = BoardHelper.get_top(i)
	var bottom: int = BoardHelper.get_bottom(i)
	var left: int = BoardHelper.get_left(i)
	var right: int = BoardHelper.get_right(i)

	var grid = Globals.grid
	return [grid[top], grid[right], grid[bottom], grid[left]]
