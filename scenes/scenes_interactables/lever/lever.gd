extends Node2D

@export var can_deactivate = false
@export var door_to_open: Node2D
@export var main_camera: Node2D
@export var camera_final_position: Node2D

signal lever_activated

var can_interact = false
var interacted_once = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if global_rotation_degrees == -90:
		$interact_key.rotation_degrees = 90
	if global_rotation_degrees == 90:
		$interact_key.rotation_degrees = -90
	if can_interact and Input.is_action_just_pressed("interact") and PlayerVars.can_control:
		$interact_key.visible = false
		$anim.play("lever_on")
		can_interact = false
		interacted_once = true
		$sfx.play()
		$particles.emitting = true
		interact()
		lever_activated.emit()

func _on_player_detection_body_entered(body: Node2D) -> void:
	if !interacted_once:
		$interact_key.visible = true
		$anim.play("highlighted_off")
		can_interact = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	$interact_key.visible = false
	can_interact = false
	if interacted_once and can_interact:
		$anim.play("highlighted_of")
	if !interacted_once:
		$anim.play("lever_off")
	if can_deactivate:
		can_interact = true
		interacted_once = false

func interact():
	PlayerVars.interacting = true
	if door_to_open:
		door_to_open.open()
	
	if main_camera:
		PlayerGui.cutscene_on()
		ScreenAnimations.cutscene_bars_on()
		PlayerVars.can_control = false
		CameraHandler.follow_player = false
		await get_tree().create_timer(1).timeout
		main_camera.position = camera_final_position.global_position
	
	if main_camera and camera_final_position:
		await get_tree().create_timer(3).timeout
		PlayerGui.cutscene_off()
		ScreenAnimations.cutscene_bars_off()
		CameraHandler.follow_player = true
		PlayerVars.can_control = true
		PlayerVars.interacting = false
