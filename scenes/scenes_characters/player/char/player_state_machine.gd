class_name Character extends CharacterBody2D


enum _StateMachine { IDLE, RUNNING, JUMP, PUNCH, LVL_END }

var _state: _StateMachine # O número aqui retorna um valor do StateMachine, começando em 0
var _enter_state := true

@onready var _animated_sprite = $anim
@onready var _hitbox = $player_hitbox/collision

@export var _player_speed = 350
@export var _jump_speed = -500.0

var can_jump = true
var jumps = 1
var punch_buffer = 0

var _Input: float: # Sistema de Input (Exclusivo do(s) jogador(es)
	get: return Input.get_axis("move_left","move_right")
	
var _ReverseInput: float: # Sistema de Input (Exclusivo do(s) jogador(es)
	get: return Input.get_axis("move_left", "move_right") * -1

var _jump_action: bool:
	get: return Input.is_action_pressed("jump")

var _punch_action: bool:
	get: return Input.is_action_just_pressed("punch")

func _physics_process(delta: float) -> void:
	match _state: # State machine que, de acordo com o Enum, executa uma função
		_StateMachine.IDLE: _idle()
		_StateMachine.RUNNING: _running()
		_StateMachine.JUMP: _jump()
		_StateMachine.PUNCH: _punch()
		_StateMachine.LVL_END: _lvl_end()
	
	PlayerVars.position_x = global_position.x
	PlayerVars.position_y = global_position.y
	
	_set_Gravity(delta)
	player_movement() # Movimentação do personagem
	move_and_slide()
	

func _enterState(animation: String) -> void: # Em suma, toca a animação que coloca lá no player.gd
	if _enter_state:
		_enter_state = false
		_animated_sprite.play(animation)

func _change_state(new_state: _StateMachine) -> void:
	if _state != new_state:
		_state = new_state
		_enter_state = true

# Estados possíveis do Player
func _idle() -> void: pass
func _running() -> void: pass
func _jump() -> void: pass
func _punch() -> void: pass
func _lvl_end() -> void: pass

func _stop_movement():
	velocity.x = velocity.x/1.2

func player_movement():
	if PlayerVars.can_control and _state != _StateMachine.PUNCH:
		if _Input > 0:
			velocity.x = _player_speed
			_animated_sprite.flip_h = false
			_hitbox.position.x = 12.2
		elif _Input < 0:
			_animated_sprite.flip_h = true
			_hitbox.position.x = 0.0
			velocity.x = -_player_speed
		else:
			_stop_movement()
		
		if _jump_action and jumps >= 1 and can_jump and is_on_floor() and PlayerVars.can_jump:
			can_jump = false
			AudioPlayer.jump_sfx()
			velocity.y = _jump_speed
			jumps = 0
			punch_buffer = 0

		elif !_jump_action:
			can_jump = true
			if _state != _StateMachine.PUNCH:
				velocity.y += -_jump_speed/40
			else:
				velocity.y += -_jump_speed
	else:
		_stop_movement()
	
func _set_Gravity(delta: float) -> void:
	if !is_on_floor():
		if _state != _StateMachine.PUNCH:
			velocity += get_gravity() * delta # Gravidade
		else:
			velocity = velocity/2
	else:
		jumps = 1
