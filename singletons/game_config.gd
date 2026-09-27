extends Node

## [VIDEO]
var fullscreen = false
var resolution = Vector2i(DisplayServer.screen_get_size())
var fps = 60

## [AUDIO]
var masterVolumeValue = 100
var ostVolumeValue = 100
var sfxVolumeValue = 100

## [MISC]
var tutorial_enabled = true
var play_intro = true

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("video", "fullscreen", false)
		config.set_value("video", "resolution", Vector2i(DisplayServer.screen_get_size()))
		config.set_value("video", "fps", 60)
		
		config.set_value("audio", "masterVolume", 1.0) # É multiplicado por 100 depois! (options_menu)
		config.set_value("audio", "ostVolume", 1.0)
		config.set_value("audio", "sfxVolume", 1.0)
		
		config.set_value("misc", "tutorial_enabled", true) # Tutorial
		config.set_value("misc", "play_intro", true) # Tutorial
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		
		## [VIDEO]
		# Fullscreen
		fullscreen = config.get_value("video", "fullscreen")
		
		# Resolução
		resolution = config.get_value("video", "resolution")
		if !fullscreen:
			DisplayServer.window_set_size(resolution)
		
		# FPS
		fps = config.get_value("video", "fps")
		Engine.max_fps = fps
		
		## [AUDIO]
		# Master Volume
		masterVolumeValue = config.get_value("audio", "masterVolume")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(masterVolumeValue))
		
		# OST Volume
		ostVolumeValue = config.get_value("audio", "ostVolume")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("OST"), linear_to_db(ostVolumeValue))
		
		# SFX Volume
		sfxVolumeValue = config.get_value("audio", "sfxVolume")
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfxVolumeValue))

		## [MISC]
		# Tutorial Ligado
		tutorial_enabled = config.get_value("misc", "tutorial_enabled")
		
		# Tocar a intro?
		play_intro = config.get_value("misc", "play_intro")

func save_audio_settings(key: String, value):
	config.set_value("audio", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_audio_settings():
	var audio_settings = {}
	for key in config.get_section_keys("audio"):
		audio_settings[key] = config.get_value("audio", key)
	return audio_settings
	
func save_video_settings(key: String, value):
	config.set_value("video", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_video_settings():
	var video_settings = {}
	for key in config.get_section_keys("video"):
		video_settings[key] = config.get_value("video", key)
	return video_settings

func save_misc_settings(key: String, value):
	config.set_value("misc", key, value)
	config.save(SETTINGS_FILE_PATH)

func load_misc_settings():
	var misc_settings = {}
	for key in config.get_section_keys("misc"):
		misc_settings[key] = config.get_value("misc", key)
	return misc_settings
