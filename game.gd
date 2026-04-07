extends Node2D


func _ready() -> void:
	%GameFSM.connect("transited", on_fsm_transited)

	var player: Player = %Board.get_node("%Player")
	Globals.player.on_player_moved.connect(on_player_moved)
	Globals.on_tile_played.connect(on_tile_played)


func on_fsm_transited(from, to) -> void:
	match from:
		"PlayTile":
			%Deck.set_enabled(false)
	match to:
		"PlayTile":
			enable_play_tile()
		"MovePlayer":
			move_player()
		_:
			print(to)


func enable_play_tile() -> void:
	%Deck.set_enabled(true)


func move_player() -> void:
	%Board.move_player()


func on_player_moved(part: PathPart) -> void:
	%GameFSM.set_trigger("move")


func on_tile_played(value: Tile, slotIndex: int) -> void:
	%GameFSM.set_trigger("play")
