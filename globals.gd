extends Node

@export var grid: Array[Slot] = []
@export var slot_size: int = 128


func initialize() -> void:
	grid = []
	grid.resize(20)


func set_slot_size(size: int) -> void:
	slot_size = size
