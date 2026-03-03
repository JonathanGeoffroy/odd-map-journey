extends Node2D

var bottom := 0


func _ready() -> void:
	bottom = %Sprite2D.texture.get_height() / 3


func initialize(player: PlayerValue) -> void:
	move_to(player.current_part)
	player.on_player_moved.connect(move_to)


func move_to(tile_part: TilePartValue) -> void:
	var offset_value := Globals.slot_size / 3
	var board := Globals.get_board()
	var slot: Slot = board.find_slot(tile_part.tile_value)

	var offset: Vector2
	match tile_part.road:
		TileValue.TileRoad.TOP:
			offset = Vector2(-offset_value, 0)
		TileValue.TileRoad.RIGHT:
			offset = Vector2(0, offset_value)
		TileValue.TileRoad.BOTTOM:
			offset = Vector2(offset_value, 0)
		TileValue.TileRoad.LEFT:
			offset = Vector2(0, -offset_value)

	global_position = (
		slot.global_position
		+ Vector2(Globals.slot_size / 2, Globals.slot_size / 2 - bottom)
		+ offset
	)
