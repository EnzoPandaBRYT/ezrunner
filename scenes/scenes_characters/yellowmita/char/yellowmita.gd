extends Character


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_multiline var dialogue_text: String
@export var interaction_id: int

var can_interact := false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		$anim.animation = "jump"
	elif velocity.x != 0:
		$anim.play("running")
	else:
		$anim.play("idle")
		
	if can_interact and Input.is_action_just_pressed("interact") and PlayerVars.can_control:
		if velocity.x == 0:
			DialogSystem.define_name("Yellowmita")
			DialogSystem.start_dialog(dialogue_text)
		else:
			match interaction_id:
				1: DialogSystem.start_dialog("Pra que me seguir?")
				2: DialogSystem.start_dialog("Já instalei os ganchos, precisa de mais alguma coisa?")
		can_interact = false
		$interact_key.visible = false
		
		await DialogSystem.dialog_finished
		
		match interaction_id:
			1:
				velocity.x += 300
			2:
				velocity.x += 300
				await get_tree().create_timer(1.0).timeout
				velocity.y -= 800
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "modulate:a", 0.0, 3)
		await tween.finished
		queue_free()
	_movement()
	move_and_slide()


func _movement():
	if velocity.x > 0:
		$anim.flip_h = false
	if velocity.x < 0:
		$anim.flip_h = true

func _on_player_detection_body_entered(body: Node2D) -> void:
	$interact_key.visible = true
	can_interact = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	$interact_key.visible = false
	can_interact = false
