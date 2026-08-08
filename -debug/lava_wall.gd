extends Node2D


func _on_body_entered(body: Node2D) -> void:
	LavaHandler.lava_speed = 0.5
	AudioPlayer.music_reduce(-5, 0.5, 0.75)
	PlayerVars.can_control = false
	$"../CanvasLayer/restarting".visible = true
	await get_tree().create_timer(2).timeout
	AudioPlayer.music_normal(0, 0.1, 1)
	$"../../../player".position = Vector2(4145,188)
	AudioPlayer.threed_world_start()
	LavaHandler.can_lava_move = false
	$".".position = Vector2(6368,-1183)
	LavaHandler.lava_speed = 1.5
	PlayerVars.can_control = true
	$"../CanvasLayer/restarting".visible = false
	
func _process(delta: float) -> void:
	if LavaHandler.can_lava_move:
		position.x += LavaHandler.lava_speed

func _on_end_body_entered(body: Node2D) -> void:
	ScreenAnimations.white_fade(1.0,3.0)
	$"../CanvasLayer/restarting".modulate = Color(0.0, 0.0, 0.0, 1.0)
	$"../CanvasLayer/restarting".visible = true
	LavaHandler.lava_speed = 0.5
	await get_tree().create_timer(3.0).timeout
	ScreenAnimations.white_fade(0.0,1.0)
	$"../../../player".position = Vector2(4145,188)
	AudioPlayer.threed_world_start()
	LavaHandler.can_lava_move = false
	$"../CanvasLayer/restarting".modulate = Color(1.0, 1.0, 1.0, 1.0)
	$"../CanvasLayer/restarting".visible = false
	$".".position = Vector2(6368,-1183)
	LavaHandler.lava_speed = 1.5
