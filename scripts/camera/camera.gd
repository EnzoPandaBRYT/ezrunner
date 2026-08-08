extends Camera2D

@onready var player = $"../player"

func _process(delta: float) -> void:
	if CameraHandler.follow_player:
		global_position = player.global_position
