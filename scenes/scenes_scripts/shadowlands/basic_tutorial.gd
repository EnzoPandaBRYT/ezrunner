extends Node2D

@onready var camera = $camera
@onready var player = $player

var id = randi_range(100000000, 999999999)

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	AudioPlayer.first_tutorial()
	ScreenAnimations.room_enter(0.0, 1)
	PlayerGui.tutorial_cutscene()
	if GameConfig.tutorial_enabled:
		player._state = player._StateMachine.JUMP
		ScreenAnimations.cutscene_bars_on(0.5)
		camera.position_smoothing_speed = 15
		create_tween().tween_property(camera, "zoom", Vector2(1.5,1.5), 3.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT) # Camera
		PlayerVars.can_control = false
		PlayerVars.can_jump = false
		PlayerVars.can_fight = false
		# Tira controle do jogador
		ScreenAnimations.room_enter(0.0, 1.0)
		
		await get_tree().create_timer(3.5).timeout
		
		TutorialHandler.tutorial_msg("Bem-vindo(a), Usuário %d." % [id])
		
		await get_tree().create_timer(3).timeout
		
		create_tween().tween_property(camera, "zoom", Vector2(2.0,2.0), 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
		
		TutorialHandler.change_text("Este mundo está em ruínas, você precisa escapar dele.")
		
		await get_tree().create_timer(5).timeout
		
		TutorialHandler.change_text("Oh. Parece que você está preso.")
		
		await get_tree().create_timer(3).timeout
		
		TutorialHandler.change_text("Tente se mexer usando WASD ou ←↑→↓.")

		await get_tree().create_timer(2).timeout
		ScreenAnimations.cutscene_bars_off(0.5)
		PlayerGui.cutscene_off()
		PlayerVars.can_control = true
	else:
		ScreenAnimations.cutscene_bars_off(0.5)
		PlayerGui.cutscene_off()
		PlayerVars.can_control = true
		camera.position_smoothing_speed = 5
		player.global_position = Vector2(72, 170)
	
func _process(delta: float) -> void:
	if PlayerVars.can_control and GameConfig.tutorial_enabled:
		match TutorialHandler.tutorial_step:
			0:
				if Input.get_axis("move_left","move_right"):
					TutorialHandler.tutorial_step = -1
					TutorialHandler.change_text("Ótimo. Você conseguiu.")
					await get_tree().create_timer(3).timeout
					TutorialHandler.change_text("Rápido, procure a saída enquanto há tempo.")
					await get_tree().create_timer(5).timeout
					TutorialHandler.change_text("Pressione ESPAÇO ou ↑ para pular sobre obstáculos.")
					await get_tree().create_timer(1).timeout
					PlayerVars.can_jump = true
					TutorialHandler.tutorial_step = 1
			1:
				if Input.is_action_just_pressed("jump"):
					TutorialHandler.tutorial_step = -1
					TutorialHandler.change_text("Maravilhoso.")
					await get_tree().create_timer(2).timeout
					TutorialHandler.change_text("Você pode SEGURAR ESPAÇO ou ↑ para pular mais alto.")
					await get_tree().create_timer(5).timeout
					TutorialHandler.change_text("Continue avançando, em breve darei mais detalhes sobre LUTAR.")
					await get_tree().create_timer(5).timeout
					TutorialHandler.tutorial_msg_end()


func _on_level_end_body_entered(body: Node2D) -> void:
	if body.name == "player":
		PlayerVars.can_control = false
		CameraHandler.follow_player = false
		ScreenAnimations.black_fade(1.0, 2)
		player._state = player._StateMachine.LVL_END
		PlayerGui.cutscene_on()
		await get_tree().create_timer(3).timeout
		TutorialHandler.tutorial_msg("Muito bem. Você conseguiu.")
		await get_tree().create_timer(4).timeout
		TutorialHandler.change_text("Mas você ainda precisa aprender a LUTAR.")
		await get_tree().create_timer(4).timeout
		AudioPlayer.music_reduce(-18, 3)
		TutorialHandler.tutorial_msg_end()
		await get_tree().create_timer(4).timeout
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://scenes/scenes_levels/shadowlands/fight_tutorial.tscn")
