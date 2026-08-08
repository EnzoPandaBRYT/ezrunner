class_name Enemy extends CharacterBody2D

enum _StateMachine { IDLE, RUNNING, JUMP, CHASE, DEAD }

var _state: _StateMachine # O número aqui retorna um valor do StateMachine, começando em 0
var _enter_state := true

@export var max_health := 3
var health = max_health

@export var mov_speed := 50

@export var use_gravity := true

@onready var _animated_sprite = $anim

func _physics_process(delta: float) -> void:
	match _state: # State machine que, de acordo com o Enum, executa uma função
		_StateMachine.IDLE: _idle()
		_StateMachine.RUNNING: _running()
		_StateMachine.JUMP: _jump()
		_StateMachine.CHASE: _chase()
		_StateMachine.DEAD: _dead()
	
	if use_gravity:
		_set_Gravity(delta)
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
func _chase() -> void: pass
func _dead() -> void: pass

func _stop_movement():
	velocity.x = velocity.x/1.2
	
func _set_Gravity(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta # Gravidade
