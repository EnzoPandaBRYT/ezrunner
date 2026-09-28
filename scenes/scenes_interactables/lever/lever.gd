extends Node2D

@export var door_to_open: Node2D
@export var camera_to_disable: Node2D
@export var camera_to_focus: Node2D

signal lever_activated

var can_interact = false
var interacted_once = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("interact"):
		$e_key.visible = false
		$anim.play("lever_on")
		can_interact = false
		interacted_once = true
		$sfx.play()
		$particles.emitting = true
		interact()
		lever_activated.emit()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if !interacted_once:
		$e_key.visible = true
		can_interact = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	$e_key.visible = false
	can_interact = false

func interact():
	if door_to_open:
		door_to_open.open()
	
	if camera_to_disable:
		PlayerVars.can_control = false
		await get_tree().create_timer(1).timeout
		camera_to_disable.enabled = false
	if camera_to_focus:
		camera_to_focus.enabled = true
	
	if camera_to_disable and camera_to_focus:
		await get_tree().create_timer(3).timeout
		camera_to_focus.enabled = false
		camera_to_disable.enabled = true
		PlayerVars.can_control = true
