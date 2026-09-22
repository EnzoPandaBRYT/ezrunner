extends Node2D

@onready var intro = $intro

@onready var camera = $menu_camera
@onready var player = $player

## OPTIONS
@onready var fullscreen_check = $options_buttons/tabs/tab_panel/video/vbox/fullscreen/check
@onready var fps_slider = $options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/slider
@onready var fps_label = $options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/fps_label
@onready var ost_volume_slider = $options_buttons/tabs/tab_panel/audio/vbox/ost_volume/slider
@onready var sfx_volume_slider = $options_buttons/tabs/tab_panel/audio/vbox/sfx_volume/slider
@onready var tutorial_check = $options_buttons/tabs/tab_panel/misc/vbox/tutorial/check
@onready var intro_check = $options_buttons/tabs/tab_panel/misc/vbox/intro/check
@onready var reset_progress_button = $options_buttons/tabs/tab_panel/misc/vbox/open_reset_button
@onready var reset_progress_panel = $options_buttons/tabs/tab_panel/misc/vbox/advanced_panel
@onready var reset_progress_warn_label = $options_buttons/tabs/tab_panel/misc/vbox/advanced_panel/vbox/label_warn

var music_time = 0.0
var is_playing_music = false

var is_tweening = false
var menu_tween: Tween
var warn_tween: Tween

func _ready() -> void:
	AudioPlayer.stop()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	ScreenAnimations.room_enter(0.0, 0.5)
	PlayerGui.tutorial_cutscene()
	PlayerVars.can_control = false
	if GameConfig.play_intro:
		var intro_tween = create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT)
		$shadowlands_tilemap.modulate.a = 0.0
		AudioPlayer.intro()
		intro_tween.tween_property(intro, "modulate:a", 1.0, 3)
		intro_tween.tween_property(camera, "position:y", 0, 1)
		await get_tree().create_timer(3).timeout
		create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN_OUT).tween_property(intro, "modulate:a", 0.0, 0.5)
	else:
		camera.position.y = 0
	if PlayerStats.tutorials_completed >= 1:
		reset_progress_button.disabled = false
		reset_progress_button.tooltip_text = ""
	else:
		reset_progress_button.disabled = true
		reset_progress_button.tooltip_text = "Você poderá reiniciar seu progresso\nquando finalizar um nível."
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	AudioPlayer.music_normal(0.0, 0.5, 1.0)
	AudioPlayer.main_menu(0.0)
	is_playing_music = true
	$options_buttons/tabs.scale = Vector2(0.0,0.0)
	game_initialize()
	await get_tree().create_timer(2).timeout
	PlayerVars.can_control = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene()
	if is_playing_music:
		music_time += delta
		if music_time >= AudioPlayer.main_menu_theme.get_length():
			music_time = 0.0
	
	if $options_buttons/tabs/confirm_reset_timer.visible:
		$options_buttons/tabs/confirm_reset_timer.text = str(int($options_buttons/tabs/confirm_reset.time_left+1))

## MAIN MENU
func _on_play_button_pressed() -> void:
	if PlayerStats.tutorials_completed == 0:
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
	start_game()
	

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
	

func _on_ost_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("OST"), linear_to_db(value/100))
	$options_buttons/tabs/tab_panel/audio/vbox/ost_volume_percentage.text = str(int(value)) + "%"
	GameConfig.save_audio_settings("ostVolume", ost_volume_slider.value/100)


func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value/100))
	$options_buttons/tabs/tab_panel/audio/vbox/sfx_volume_percentage.text = str(int(value)) + "%"
	GameConfig.save_audio_settings("sfxVolume", sfx_volume_slider.value/100)

func _on_fps_value_changed(value: float) -> void:
	fps_label.text = str(int(value))
	Engine.max_fps = int(value)
	GameConfig.save_video_settings("fps", value)

func _on_fullscreen_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		GameConfig.save_video_settings("fullscreen", true)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		GameConfig.save_video_settings("fullscreen", false)
		
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

func _on_tutorial_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameConfig.save_misc_settings("tutorial_enabled", true)
	else:
		GameConfig.save_misc_settings("tutorial_enabled", false)


func _on_intro_check_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameConfig.save_misc_settings("play_intro", true)
	else:
		GameConfig.save_misc_settings("play_intro", false)

func game_initialize():
	
	# Tela cheia
	if GameConfig.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		fullscreen_check.button_pressed = true
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		fullscreen_check.button_pressed = false
	
	# FPS
	fps_slider.value = GameConfig.fps
	fps_label.text = str(int(GameConfig.fps))
	
	# Volume da OST
	ost_volume_slider.value = GameConfig.ostVolumeValue*100
	# Volume dos SFX
	sfx_volume_slider.value = GameConfig.sfxVolumeValue*100
	
	# Tutorial
	if GameConfig.tutorial_enabled:
		tutorial_check.button_pressed = true
	else:
		tutorial_check.button_pressed = false
		
	# Intro
	if GameConfig.play_intro:
		intro_check.button_pressed = true
	else:
		intro_check.button_pressed = false
	
	if PlayerStats.tutorials_completed >= 2:
		$options_buttons/tabs/tab_panel/misc/vbox/tutorial/check.disabled = false
		$options_buttons/tabs/tab_panel/misc/vbox/tutorial/check.tooltip_text = ""
		$options_buttons/tabs/tab_panel/misc/vbox/tutorial/label.tooltip_text = ""

func start_game():
	# Vê qual nível o jogador tá:
	if PlayerStats.tutorials_completed <= 2:
		match PlayerStats.tutorials_completed:
			0: 
				get_tree().change_scene_to_file("res://scenes/scenes_levels/shadowlands/basic_tutorial.tscn")
			1: 
				get_tree().change_scene_to_file("res://scenes/scenes_levels/shadowlands/fight_tutorial.tscn")
			2: 
				get_tree().change_scene_to_file("res://scenes/scenes_levels/shadowlands/1_allium.tscn")
			

func reset_settings():
	if FileAccess.file_exists("user://player_stats.ini"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://player_stats.ini"))
		
	ScreenAnimations.black_fade(1.0, 3)
	AudioPlayer.music_reduce(-18, 4, 0.5)
	AudioPlayer.main_menu_end()
	shrink_window()
	await get_tree().create_timer(5).timeout
	get_tree().quit()

func _on_open_reset_menu_pressed() -> void:
	warn_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
	reset_progress_warn_label.visible_characters = 0
	reset_progress_warn_label.add_theme_color_override("font_color", Color(0.412, 0.406, 0.0))
	warn_tween.tween_property(reset_progress_warn_label, "visible_characters", reset_progress_warn_label.text.length(), 2)
	$options_buttons/tabs/confirm_reset.start()
	reset_progress_panel.visible = true
	reset_progress_button.disabled = true
	$options_buttons/tabs/tab_panel/misc/vbox/advanced_panel/vbox/you_sure/yes.disabled = true
	$options_buttons/tabs/confirm_reset_timer.visible = true
	warn_tween.tween_property(reset_progress_warn_label, "theme_override_colors/font_color", Color(0.831, 0.819, 0.0), 3)
	
func _on_confirm_reset_pressed() -> void:
	reset_settings()


func _on_deny_reset_pressed() -> void:
	reset_progress_panel.visible = false
	reset_progress_button.disabled = false
	$options_buttons/tabs/confirm_reset_timer.visible = false
	warn_tween.kill()


func _on_confirm_reset_timeout() -> void:
	$options_buttons/tabs/tab_panel/misc/vbox/advanced_panel/vbox/you_sure/yes.disabled = false
	$options_buttons/tabs/confirm_reset_timer.visible = false
