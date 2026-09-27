extends Character


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_multiline var dialogue_text: String

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
		
	if can_interact and Input.is_action_just_pressed("interact"):
		if velocity.x == 0:
			DialogSystem.start_dialog(dialogue_text)
		else:
			DialogSystem.start_dialog("Pra que me seguir?")
		can_interact = false
		$e_key.visible = false
		await get_tree().create_timer(12).timeout
		velocity.x += 300
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(self, "modulate:a", 0.0, 3)
		await tween.finished
		queue_free()
			
	move_and_slide()


func _on_player_detection_body_entered(body: Node2D) -> void:
	$e_key.visible = true
	can_interact = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	$e_key.visible = false
	can_interact = false
