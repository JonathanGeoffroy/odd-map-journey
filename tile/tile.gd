extends Node2D
class_name Tile

@export var MOVE_TIME := 0.5

var is_selected := false

static var textures: Array[Texture2D] = [
	preload("res://tile/assets/top_bottom.png"),
	preload("res://tile/assets/top_left.png"),
	preload("res://tile/assets/top_left_right.png"),
	preload("res://tile/assets/all.png")
]

@export var value: TileValue
var previous_position = null


func _ready() -> void:
	%Sprite2D.texture = textures[value.kind]
	%Sprite2D.centered = false

	Globals.on_selection_change.connect(on_selection_change)


func _process(delta: float) -> void:
	if value.errored:
		set_modulate(Color(1, 0, 0, 1))
	else:
		set_modulate(Color.WHITE)

	if self.value == Globals.selected_tile:
		var mouse_position = get_global_mouse_position()
		var offset = Globals.slot_size / 2
		global_position = Vector2(mouse_position.x - offset, mouse_position.y - offset)


func set_selected(selected: bool):
	is_selected = selected

	if is_selected:
		set_modulate(Color(0, 1, 0, 1))
		previous_position = position
	else:
		set_modulate(Color.WHITE)
		if previous_position != null:
			position = previous_position
			previous_position = null


func on_selection_change(tile_value: TileValue) -> void:
	var selected = value == tile_value
	set_selected(selected)
	if !selected:
		value.errored = false
