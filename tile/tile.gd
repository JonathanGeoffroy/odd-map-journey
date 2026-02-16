extends Node2D
class_name Tile

var is_selected := false

static var textures: Array[Texture2D] = [
	preload("res://tile/assets/top_bottom.png"),
	preload("res://tile/assets/top_left.png"),
	preload("res://tile/assets/top_left_right.png"),
	preload("res://tile/assets/all.png")
]

@export var value: TileValue


func _ready() -> void:
	%Sprite2D.texture = textures[value.kind]
	%Sprite2D.centered = false

	Globals.on_selection_change.connect(on_selection_change)


func set_selected(selected: bool):
	is_selected = selected

	if is_selected:
		$Sprite2D.set_modulate(Color(1, 0, 0, 1))
	else:
		$Sprite2D.set_modulate(Color.WHITE)


func on_selection_change(tile_value: TileValue) -> void:
	set_selected(true if value == tile_value else false)
