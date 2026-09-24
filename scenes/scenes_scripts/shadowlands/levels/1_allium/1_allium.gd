extends Node2D

var standing_batch_scene = preload("res://scenes/scenes_characters/enemies/batch/standing_batch.tscn") # Batch parado
var batch_scene = preload("res://scenes/scenes_characters/enemies/batch/batch.tscn") # Batch normal
var thunderbolt_scene = preload("res://scenes/scenes_characters/attacks/thunderbolt/thunderbolt.tscn")

@onready var player = $player
@onready var camera = $main_camera

var total_enemies_to_spawn = 0 # Número de inimigos que irão spawnar na arena
var enemies_alive = 0 # Número de inimigos vivos naquela arena
var actual_arena = 0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	AudioPlayer.music_normal(0.0, 1)
	AudioPlayer._1_allium()
	ScreenAnimations.cutscene_bars_on(0.5)
	ScreenAnimations.room_enter(0.0, 1.0)
	PlayerGui.level_start()
	PlayerVars.can_control = false
	CameraHandler.follow_player = false
	if GameConfig.tutorial_enabled:
		player.position = Vector2(-679,273)
		TutorialHandler.tutorial_step = 2
		player._state = player._StateMachine.LVL_END
	else:
		TutorialHandler.tutorial_step = -1
		PlayerVars.can_control = true
		CameraHandler.follow_player = true
		
	
	
func _on_level_start_body_entered(body: Node2D) -> void:
	ScreenAnimations.cutscene_bars_off(0.5)
	PlayerGui.cutscene_off()
	PlayerVars.can_control = true
	CameraHandler.follow_player = true
	$level_start.queue_free()

func _spawn_standing_batch(pos: Vector2):
	var enemy = standing_batch_scene.instantiate()
	enemy.global_position = pos
	add_child(enemy)

func _spawn_batch(pos: Vector2):
	var enemy = batch_scene.instantiate()
	total_enemies_to_spawn -= 1
	enemies_alive += 1
	enemy.global_position = pos
	add_child(enemy)
	enemy.enemy_dead.connect(_enemy_died)

func _enemy_died():
	var enemies_to_spawn: int
	enemies_alive -= 1
	if total_enemies_to_spawn > 0:
		if total_enemies_to_spawn >= 2: # Se o total de inimigos que faltam spawnar for maior que 1
			enemies_to_spawn = randi_range(1,2)
		else:
			enemies_to_spawn = 1
		await get_tree().create_timer(randf_range(0.5,1.0)).timeout
		match actual_arena:
			1:
				while enemies_to_spawn > 0: # Faz nascer mais de um inimigo, se for o caso.
					_spawn_batch($enemy_spawns/arena_1.get_node("bat_spawn_" + str(randi_range(1,3))).position)
					enemies_to_spawn -= 1
			2:
				_spawn_batch($enemy_spawns/arena_2.get_node("bat_spawn_" + str(randi_range(1,4))).position)
	else:
		match actual_arena:
			2:
				var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
				tween.tween_property($enemy_spawns/arena_2/wall, "position", Vector2(position.x,position.y+700),2)
				var t_camera = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true)
				t_camera.tween_property(camera, "global_position", Vector2(PlayerVars.position_x,PlayerVars.position_y),1)
				t_camera.tween_property(camera, "zoom", Vector2(2,2),1)
				await t_camera.finished
				CameraHandler.follow_player = true

func spawn_thunder(pos: Vector2) -> void:
	var thunder = thunderbolt_scene.instantiate()
	add_child(thunder)
	thunder.invoke_thunder(pos)

func _on_arena_1_start_body_entered(body: Node2D) -> void:
	if body.name == "player":
		actual_arena = 1
		total_enemies_to_spawn = 3
		$enemy_spawns/arena_1/arena_1_start.queue_free()
		await get_tree().create_timer(0.5).timeout
		_spawn_batch($enemy_spawns/arena_1.get_node("bat_spawn_" + str(randi_range(1,3))).position)

func _on_arena_2_start_body_entered(body: Node2D) -> void:
	if body.name == "player":
		actual_arena = 2
		total_enemies_to_spawn = 8
		$enemy_spawns/arena_2/arena_2_start.queue_free()
		## EFEITOS DE CAMERA:
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO).set_parallel(true)
		tween.tween_property($enemy_spawns/arena_2/wall, "position", Vector2(position.x,position.y-700),3)
		CameraHandler.follow_player = false
		tween.tween_property(camera, "global_position", Vector2(4586,-1123),1)
		tween.tween_property(camera, "zoom", Vector2(1.5,1.5),1)
		await get_tree().create_timer(1).timeout
		_spawn_batch($enemy_spawns/arena_2.get_node("bat_spawn_" + str(randi_range(1,4))).position)


func _on_level_end_body_entered(body: Node2D) -> void:
	if body.name == "player":
		PlayerStats.save_levels_settings("tutorials_completed", 2)
		PlayerVars.can_control = false
		CameraHandler.follow_player = false
		ScreenAnimations.black_fade(1.0, 2)
		player._state = player._StateMachine.LVL_END
		PlayerGui.cutscene_on()
		await get_tree().create_timer(3).timeout
		AudioPlayer.music_reduce(-9, 3)
		TutorialHandler.tutorial_msg("Você está indo bem.")
		await get_tree().create_timer(4).timeout
		TutorialHandler.change_text("Entretanto Shadowlands ainda é um lugar\ncom muito sofrimento...")
		await get_tree().create_timer(5).timeout
		TutorialHandler.change_text("Talvez um dia esse lugar seja livre, como era antes.")
		await get_tree().create_timer(5).timeout
		AudioPlayer.music_reduce(-18, 3)
		TutorialHandler.tutorial_msg_end()
		await get_tree().create_timer(4).timeout
		await get_tree().process_frame
		get_tree().change_scene_to_file("res://scenes/scenes_gui/main_menu/main_menu.tscn")
