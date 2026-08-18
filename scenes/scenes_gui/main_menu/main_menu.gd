extends Node2D

@onready var camera = $menu_camera
@onready var player = $player

## OPTIONS
@onready var fullscreen_check = $options_buttons/tabs/tab_panel/video/vbox/fullscreen/check

var music_time = 0.0
var is_playing_music = false

var is_tweening = false
var menu_tween: Tween

func _ready() -> void:
	grow_window()
	PlayerVars.can_control = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ScreenAnimations.room_enter(0.0, 1)
	AudioPlayer.music_normal(0.0, 0.5, 1.0)
	AudioPlayer.main_menu(0.0)
	is_playing_music = true
	PlayerGui.tutorial_cutscene()
	$options_buttons/tabs.scale = Vector2(0.0,0.0)
	await get_tree().create_timer(2).timeout
	PlayerVars.can_control = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if is_playing_music:
		music_time += delta
		if music_time >= AudioPlayer.main_menu_theme.get_length():
			music_time = 0.0

## MAIN MENU
func _on_play_button_pressed() -> void:
	shrink_window()
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
	if menu_tween and menu_tween.is_running():
		return
	AudioPlayer.main_menu_options(AudioPlayer.ost_player.get_playback_position(), 0.5)
	menu_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	
	menu_tween.tween_property(camera,"position:x", 1920, 0.5)
	menu_tween.tween_property($main_menu_buttons, "position", Vector2(0,1000), 0.2)
	menu_tween.tween_property($options_buttons/back_button, "position", Vector2(1970,850), 2)
	menu_tween.tween_property($options_buttons/tabs, "scale", Vector2(1.0,1.0), 1)
	
	$parallax/rocks.autoscroll.x = 30
	$parallax/darker_terrain.autoscroll.x = 30
	$parallax/terrain.autoscroll.x = 20
	
	await menu_tween.finished
	
func _on_exit_button_pressed() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	shrink_window()
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
	if menu_tween and menu_tween.is_running():
		return
	AudioPlayer.main_menu(AudioPlayer.ost_player.get_playback_position(), 0.5)
	menu_tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	
	menu_tween.tween_property(camera,"position:x", 0, 0.5)
	menu_tween.tween_property($options_buttons/tabs, "scale", Vector2(0.0,0.0), 0.2)
	menu_tween.tween_property($options_buttons/back_button, "position", Vector2(1970,1200), 0.2)
	menu_tween.tween_property($main_menu_buttons, "position", Vector2(-0,0), 1)
	
	$parallax/rocks.autoscroll.x = 60
	$parallax/darker_terrain.autoscroll.x = 10
	$parallax/terrain.autoscroll.x = 5
	
	await menu_tween.finished
	

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("OST"), linear_to_db(value/100))
	$options_buttons/tabs/tab_panel/audio/vbox/music_volume_percentage.text = str(int(value)) + "%"


func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value/100))
	$options_buttons/tabs/tab_panel/audio/vbox/sfx_volume_percentage.text = str(int(value)) + "%"

func _on_fps_value_changed(value: float) -> void:
	$options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/fps_label.text = str(int(value))
	Engine.max_fps = int(value)

func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func _on_vsync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		$options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/slider.editable = false
		Engine.max_fps = 0
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		$options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/slider.editable = true
		Engine.max_fps = int($options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/slider.value)

func _on_advanced_video_settings_button_pressed() -> void:
	$options_buttons/tabs/tab_panel/video/vbox/advanced_panel.visible = !$options_buttons/tabs/tab_panel/video/vbox/advanced_panel.visible
	if $options_buttons/tabs/tab_panel/video/vbox/advanced_panel.visible:
		$options_buttons/tabs/tab_panel/video/vbox/advanced_button.text = "▼ Configurações Avançadas"
	else:
		$options_buttons/tabs/tab_panel/video/vbox/advanced_button.text = "▶ Configurações Avançadas"

func grow_window():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	
	var start_size = Vector2i(0,0)
	var target_size = DisplayServer.window_get_size()
	var start_pos = Vector2i(DisplayServer.window_get_size().x/2,DisplayServer.window_get_size().y/2)
	var mid_screen = Vector2i(0,0)
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	tween.tween_property(self, "modulate:a", 1.0, 1)
	tween.tween_method(func(size):DisplayServer.window_set_size(Vector2i(size)),Vector2(start_size),Vector2(target_size), 1)
	tween.tween_method(func(pos):DisplayServer.window_set_position(Vector2i(pos)),Vector2(start_pos),Vector2(mid_screen), 1)

func shrink_window():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	var tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	
	var start_size = DisplayServer.window_get_size()
	var target_size = Vector2i(0,0)
	var start_pos = DisplayServer.window_get_position()
	var mid_screen = Vector2i(DisplayServer.window_get_size().x/2,DisplayServer.window_get_size().y/2)
	
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	tween.tween_property(self, "modulate:a", 0.0, 4)
	tween.tween_method(func(size):DisplayServer.window_set_size(Vector2i(size)),Vector2(start_size),Vector2(target_size), 4)
	tween.tween_method(func(pos):DisplayServer.window_set_position(Vector2i(pos)),Vector2(start_pos),Vector2(mid_screen), 4)
