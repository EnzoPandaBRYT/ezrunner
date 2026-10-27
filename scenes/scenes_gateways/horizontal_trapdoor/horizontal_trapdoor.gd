extends Node2D

@export var go_to: Node2D
@export var player: Character

var can_interact = false
@export var door_opened = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if door_opened:
		global_position.x = global_position.x-150

func open():
	await get_tree().create_timer(2).timeout
	door_opened = true
	$particles.emitting = true
	var tween = create_tween()
	var random = randi_range(1,2)
	match random:
		1: $sfx_01.play()
		2: $sfx_02.play()
	tween.tween_property(self, "global_position:x", global_position.x-150, 3)
