extends Node2D

@onready var thunder = preload("res://scenes/scenes_characters/attacks/thunderbolt/thunderbolt.tscn")

func _ready() -> void:
	var player_position = Vector2(PlayerVars.position_x, PlayerVars.position_y)
	AudioPlayer.threed_world_start()
	ScreenAnimations.black_fade(1.0, 0.0)
	await get_tree().create_timer(0.5).timeout
	ScreenAnimations.black_fade(0.0, 0.5)
	
	
