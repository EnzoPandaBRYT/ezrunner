extends Character

@onready var player_anim = $anim

func _idle():
	_stop_movement()
	
	if PlayerVars.can_control:
		if is_on_floor():
			_enterState("idle")
		
		if _jump_action and can_jump and PlayerVars.can_jump:
			_change_state(_StateMachine.JUMP)
			
		
		if _Input and is_on_floor():
			_change_state(_StateMachine.RUNNING)
		
		if _punch_action and PlayerVars.can_fight:
			_change_state(_StateMachine.PUNCH)
	else:
		if is_on_floor():
			_enterState("idle")
	

func _running():
	_enterState("running")
	if _jump_action and can_jump and PlayerVars.can_jump or !is_on_floor():
		_change_state(_StateMachine.JUMP)
	
	if !_Input or !PlayerVars.can_control:
		_change_state(_StateMachine.IDLE)
	
	if _punch_action and PlayerVars.can_fight:
		_change_state(_StateMachine.PUNCH)
	
	
func _jump():
	_enterState("jump")
	player_movement()
	
	if is_on_floor():
		if !_Input:
			if !_jump_action or !can_jump:
				_change_state(_StateMachine.IDLE)
		else:
			if !_jump_action or !can_jump:
				_change_state(_StateMachine.RUNNING)
	else:
		if _punch_action and PlayerVars.can_fight:
			_change_state(_StateMachine.PUNCH)
	

func _punch():
	_enterState("punch")
	
	$player.play("punch")
	await $player.animation_finished
	_change_state(_StateMachine.IDLE)
	PlayerVars.last_dir = _Input
	
func _lvl_end():
	_enterState("running")
	if !PlayerVars.can_control:
		velocity.x = _player_speed
	else:
		_change_state(_StateMachine.IDLE)

# Script pro jogador tomar dano
func _on_player_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "batch_hitbox":
		PlayerGui.update_health(-5)
	if area.name == "thunder_hitbox":
		PlayerGui.update_health(-20)
