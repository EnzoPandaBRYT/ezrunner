extends Node

## Script da camera
@onready var camera = $"../main_camera"
@onready var player = $"../../player"

func _process(_delta: float) -> void:
	camera.position = player.position
