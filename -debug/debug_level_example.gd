extends Node2D

func _ready() -> void:
	AudioPlayer.threed_world_start()
	ScreenAnimations.black_fade(1.0, 0.0)
	await get_tree().create_timer(0.5).timeout
	ScreenAnimations.black_fade(0.0, 0.5)
	
