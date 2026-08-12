extends Node2D

@onready var camera = $menu_camera
@onready var player = $player

func _ready() -> void:
	PlayerVars.can_control = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ScreenAnimations.room_enter(0.0, 1)
	AudioPlayer.music_normal(0.0, 0.5, 1.0)
	AudioPlayer.main_menu()
	PlayerGui.tutorial_cutscene()
	await get_tree().create_timer(2).timeout
	PlayerVars.can_control = true


## MAIN MENU
func _on_play_button_pressed() -> void:
	PlayerVars.can_control = false
	player.velocity.y += -3000
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property($main_menu_buttons, "position", Vector2(-1000,0), 3)
	AudioPlayer.main_menu_end()
	AudioPlayer.music_reduce(-40, 4)
	ScreenAnimations.black_fade(1.0, 2)
	await get_tree().create_timer(4).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/scenes_levels/shadowlands/basic_tutorial.tscn")

func _on_options_button_pressed() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property(camera,"position:x", 1920, 0.5)
	tween.tween_property($main_menu_buttons, "position", Vector2(0,1000), 0.2)
	tween.tween_property($options_buttons/back_button, "position", Vector2(1970,750), 1)

func _on_exit_button_pressed() -> void:
	PlayerVars.can_control = false
	player.velocity.y += -3000
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property($main_menu_buttons, "position", Vector2(-1000,1000), 3)
	AudioPlayer.main_menu_end()
	AudioPlayer.music_reduce(-40, 4)
	ScreenAnimations.black_fade(1.0, 2)
	await get_tree().create_timer(5).timeout
	get_tree().quit()


## OPTIONS MENU
func _on_back_button_pressed() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	tween.tween_property(camera,"position:x", 0, 0.5)
	tween.tween_property($main_menu_buttons, "position", Vector2(-0,0), 1)
	tween.tween_property($options_buttons/back_button, "position", Vector2(1970,1200), 0.2)
