extends Node

var tutorials_completed = 0
var levels_completed = 0

var batchs_killed = 0

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://player_stats.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("levels", "tutorials_completed", 0)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)
		
		## [TUTORIAL]
		tutorials_completed = config.get_value("levels", "tutorials_completed")
		print(tutorials_completed)

func save_levels_settings(key: String, value):
	config.set_value("levels", key, value)
	config.save(SETTINGS_FILE_PATH)
	
func load_levels_settings():
	var levels_settings = {}
	for key in config.get_section_keys("levels"):
		levels_settings[key] = config.get_value("levels", key)
	return levels_settings
