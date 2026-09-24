extends Node2D

@onready var options = $canvas/options_buttons
@onready var quit = $canvas/node/quit

## OPTIONS
@onready var fullscreen_check = $canvas/options_buttons/tabs/tab_panel/video/vbox/fullscreen/check
@onready var fps_slider = $canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/slider
@onready var fps_label = $canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/fps_label
@onready var ost_volume_slider = $canvas/options_buttons/tabs/tab_panel/audio/vbox/ost_volume/slider
@onready var sfx_volume_slider = $canvas/options_buttons/tabs/tab_panel/audio/vbox/sfx_volume/slider
@onready var tutorial_check = $canvas/options_buttons/tabs/tab_panel/misc/vbox/tutorial/check
@onready var intro_check = $canvas/options_buttons/tabs/tab_panel/misc/vbox/intro/check
@onready var reset_progress_button = $canvas/options_buttons/tabs/tab_panel/misc/vbox/open_reset_button
@onready var reset_progress_panel = $canvas/options_buttons/tabs/tab_panel/misc/vbox/advanced_panel
@onready var reset_progress_warn_label = $canvas/options_buttons/tabs/tab_panel/misc/vbox/advanced_panel/vbox/label_warn

var menu_tween: Tween

func _ready() -> void:
	$canvas.visible = false
	$canvas/node.modulate = Color(0.0, 0.0, 0.0, 0.0)
	$canvas/options_buttons.modulate = Color(0.0, 0.0, 0.0, 0.0)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if !ScreenAnimations.animation_playing:
			pause()
	$canvas/mouse_particles.position = get_viewport().get_mouse_position()
	
func pause():
	if !get_tree().paused:
		fade_in()
	elif get_tree().paused:
		fade_out()
		options_out()

func fade_in():
	$canvas.visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($canvas/node, "modulate", Color(1.0,1.0,1.0,1.0), 0.25)
	tween.tween_property($canvas/rect, "modulate", Color(1.0,1.0,1.0,1.0), 0.25)
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	AudioPlayer.pause_music_effect()

func fade_out(time := 0.10):
	$canvas.visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($canvas/node, "modulate", Color(0.0, 0.0, 0.0, 0.0), time)
	tween.tween_property($canvas/rect, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.25)
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	get_tree().paused = false
	AudioPlayer.resume_music_effect()
	await get_tree().create_timer(time).timeout
	$canvas.visible = false

func options_in():
	ost_volume_slider.value = GameConfig.config.get_value("audio", "ostVolume")*100
	sfx_volume_slider.value = GameConfig.config.get_value("audio", "sfxVolume")*100
	$canvas/options_buttons/tabs/tab_panel/audio/vbox/ost_volume_percentage.text = str(int(GameConfig.config.get_value("audio", "ostVolume")*100)) + "%"
	$canvas/options_buttons/tabs/tab_panel/audio/vbox/sfx_volume_percentage.text = str(int(GameConfig.config.get_value("audio", "sfxVolume")*100)) + "%"
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_property($canvas/node, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.25)
	options.visible = true
	tween.tween_property(options, "modulate", Color(1.0,1.0,1.0,1.0), 0.25)
	tween.tween_property($canvas/options_buttons/back_button, "position", Vector2(100, 890), 0.50)

func options_out():
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_property($canvas/options_buttons/back_button, "position", Vector2(100, 1100), 0.50)
	tween.tween_property(options, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.25)
	options.visible = true
	tween.tween_property($canvas/node, "modulate", Color(1.0,1.0,1.0,1.0), 0.25)
	await tween.finished
	options.visible = false

func _on_back_to_game_pressed() -> void:
	get_tree().paused = false
	fade_out()
	await get_tree().create_timer(1.0).timeout

func _on_settings_pressed() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_property($canvas/node, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.25)
	options.visible = true
	tween.tween_property(options, "modulate", Color(1.0,1.0,1.0,1.0), 0.25)
	tween.tween_property($canvas/options_buttons/back_button, "position", Vector2(100, 890), 0.50)
	
func _on_quit_pressed() -> void:
	get_tree().paused = false
	fade_out(1.0)
	ScreenAnimations.black_fade(1.0, 1.0)
	AudioPlayer.quit_game_music_effect()
	AudioPlayer.music_reduce(-18, 1.0)
	await get_tree().create_timer(1.0).timeout
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://scenes/scenes_gui/main_menu/main_menu.tscn")

## OPTIONS MENU
func _on_back_button_pressed() -> void:
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUART).set_parallel(true)
	tween.tween_property($canvas/options_buttons/back_button, "position", Vector2(100, 1100), 0.50)
	tween.tween_property(options, "modulate", Color(0.0, 0.0, 0.0, 0.0), 0.25)
	options.visible = true
	tween.tween_property($canvas/node, "modulate", Color(1.0,1.0,1.0,1.0), 0.25)
	await tween.finished
	options.visible = false

### VIDEO
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
		$canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/slider.editable = false
		Engine.max_fps = 0
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		$canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/slider.editable = true
		Engine.max_fps = int($canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_panel/vbox/fps/slider.value)

func _on_use_own_cursor_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$canvas/mouse_particles.emitting = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		$canvas/mouse_particles.emitting = true
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	
func _on_advanced_video_settings_button_pressed() -> void:
	$canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_panel.visible = !$canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_panel.visible
	if $canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_panel.visible:
		$canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_button.text = "▼ Configurações Avançadas"
	else:
		$canvas/options_buttons/tabs/tab_panel/video/vbox/advanced_button.text = "▶ Configurações Avançadas"

func _on_fps_value_changed(value: float) -> void:
	fps_label.text = str(int(value))
	Engine.max_fps = int(value)
	GameConfig.save_video_settings("fps", value)
	
### AUDIO
func _on_ost_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("OST"), linear_to_db(value/100))
	$canvas/options_buttons/tabs/tab_panel/audio/vbox/ost_volume_percentage.text = str(int(value)) + "%"
	GameConfig.save_audio_settings("ostVolume", ost_volume_slider.value/100)

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value/100))
	$canvas/options_buttons/tabs/tab_panel/audio/vbox/sfx_volume_percentage.text = str(int(value)) + "%"
	GameConfig.save_audio_settings("sfxVolume", sfx_volume_slider.value/100)
