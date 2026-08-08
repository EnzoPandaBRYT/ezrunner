extends Node
## Area inicial
var camera_follow = false
@onready var camera = $"../main_camera"
@onready var camera_2 = $camera_2
@onready var player = $"../../player"

func _on_start_area_body_entered(_body: Node2D) -> void:
	camera_2.enabled = false
	camera.enabled = true

func _on_start_area_body_exited(_body: Node2D) -> void:
	camera.enabled = false # Cam 1 é desligada
	camera_2.enabled = true # Cam 2 é ligada
		
func _on_start_area_end_body_entered(_body: Node2D) -> void:
	camera_2.enabled = false # Cam 2 é desligada
	camera.enabled = true # Cam 1 é ligada com o fim da área
