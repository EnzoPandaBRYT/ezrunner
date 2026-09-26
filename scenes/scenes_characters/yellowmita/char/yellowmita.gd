extends Character


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_multiline var dialogue_text: String

var can_interact := false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if can_interact and Input.is_action_just_pressed("interact"):
		DialogSystem.start_dialog(dialogue_text)
		can_interact = false
	
	move_and_slide()


func _on_player_detection_body_entered(body: Node2D) -> void:
	$e_key.visible = true
	can_interact = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	$e_key.visible = false
	can_interact = false
	DialogSystem.dialog_end()
