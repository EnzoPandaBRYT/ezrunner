extends Node2D

var standing_batch_scene = preload("res://scenes/scenes_characters/enemies/batch/standing_batch.tscn")
var batch_scene = preload("res://scenes/scenes_characters/enemies/batch/batch.tscn")

@onready var player = $player

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	AudioPlayer.music_normal(0.0, 1)
	AudioPlayer.first_tutorial()
	ScreenAnimations.room_enter(0.0, 1.0)
	PlayerVars.can_control = false
	CameraHandler.follow_player = false
	PlayerGui.cutscene_off()
	if GameConfig.tutorial_enabled:
		TutorialHandler.tutorial_step = 2
		player._state = player._StateMachine.LVL_END
	else:
		TutorialHandler.tutorial_step = -1
		player.position = Vector2(63.0, 204.0)
		

func _process(delta: float) -> void:
	match TutorialHandler.tutorial_step:
		2:
			if PlayerStats.batchs_killed >= 1:
				TutorialHandler.tutorial_step = -1
				await get_tree().create_timer(1).timeout
				TutorialHandler.change_text("Ótimo. Você eliminou ele.")
				await get_tree().create_timer(2).timeout
				TutorialHandler.change_text("Geralmente 3 socos são suficientes para\neliminá-los, mas você pode precisar\nde mais.")
				await get_tree().create_timer(7).timeout
				TutorialHandler.change_text("Bom, preciso ir. Boa sorte na sua jornada.")
				await get_tree().create_timer(3).timeout
				TutorialHandler.change_text("Ah, e a propósito, me chamo Laupiy.")
				await get_tree().create_timer(3).timeout
				_spawn_batch($enemy_spawns/initial_area/second_batch.position)
				TutorialHandler.tutorial_msg_end()
				

func _on_level_start_body_entered(body: Node2D) -> void:
	PlayerVars.can_control = true
	CameraHandler.follow_player = true
	$level_start.queue_free()
	if GameConfig.tutorial_enabled:
		await get_tree().create_timer(0.5).timeout
		PlayerVars.can_control = false
		TutorialHandler.tutorial_msg("Agora que você chegou aqui,")
		await get_tree().create_timer(3).timeout
		TutorialHandler.change_text("deverá aprender a como LUTAR.")
		await get_tree().create_timer(2.5).timeout
		TutorialHandler.change_text("Apesar de parecer, as criaturas de SHADOWLANDS\nnão são nada tranquilas...")
		await get_tree().create_timer(5).timeout
		TutorialHandler.change_text("Então vamos começar.")
		await get_tree().create_timer(2).timeout
		TutorialHandler.change_text("Aperte F para socar esse inimigo.")
		PlayerVars.can_control = true
		PlayerVars.can_fight = true
		_spawn_standing_batch($enemy_spawns/initial_area/first_batch.position)
	else:
		PlayerVars.can_control = true
		_spawn_batch($enemy_spawns/initial_area/first_batch.position)
		await get_tree().create_timer(1).timeout
		_spawn_batch($enemy_spawns/initial_area/second_batch.position)
		await get_tree().create_timer(1).timeout
		_spawn_batch($enemy_spawns/initial_area/third_batch.position)

func _on_arena_1_start_body_entered(body: Node2D) -> void:
	if body.name == "player":
		$enemy_spawns/arena_1/arena_1_start.queue_free()
		await get_tree().create_timer(1).timeout
		_spawn_batch($enemy_spawns/arena_1/bat_spawn_1.position)
		await get_tree().create_timer(1).timeout
		_spawn_batch($enemy_spawns/arena_1/bat_spawn_2.position)
		await get_tree().create_timer(3).timeout
		_spawn_batch($enemy_spawns/arena_1/bat_spawn_3.position)

func _spawn_standing_batch(pos: Vector2):
	var enemy = standing_batch_scene.instantiate()
	enemy.global_position = pos
	add_child(enemy)

func _spawn_batch(pos: Vector2):
	var enemy = batch_scene.instantiate()
	enemy.global_position = pos
	add_child(enemy)
