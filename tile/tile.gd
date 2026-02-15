extends Node2D
class_name Tile

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
