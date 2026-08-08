extends Node
## Area 2
var camera_follow = false
@onready var camera = $"../main_camera"
@onready var camera_2 = $camera_3
@onready var player = $"../../player"

func _on_start_area_body_entered(_body: Node2D) -> void:
	camera.enabled = false # Cam 1 é desligada
	camera_2.enabled = true # Cam 2 é ligada

func _on_start_area_body_exited(_body: Node2D) -> void:
	PlayerVars.can_control = false
	$"../../cinematics/lava_test/anim_player".play("lava_cam")
	ScreenAnimations.cutscene_bars_on()
	ScreenAnimations.white_fade(1.0,3.0)
	AudioPlayer.threed_world_end()
	player.position = Vector2(6788.0, -486)
	await get_tree().create_timer(3.0).timeout
	ScreenAnimations.cutscene_bars_off()
	ScreenAnimations.white_fade(0.0, 0.5)
	PlayerVars.can_control = true
	LavaHandler.can_lava_move = true
	await get_tree().create_timer(26.0).timeout
	
