extends Node2D

@export var go_to: Node2D
@export var player: Character

var can_interact = false
@export var door_opened = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if door_opened and can_interact and Input.is_action_just_pressed("interact"):
		$e_key.visible = false
		interact()

func open():
	door_opened = true
	await get_tree().create_timer(2).timeout
	$anim.play("door_open")
	$particles.emitting = true

func _on_player_detection_body_entered(body: Node2D) -> void:
	if door_opened:
		can_interact = true
		$anim.play("door_open")
		$e_key.visible = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	if door_opened:
		can_interact = false
		$anim.play("door_closed")
		$e_key.visible = false

func interact():
	PlayerVars.can_control = false
	player.visible = false
	ScreenAnimations.black_fade(1.0, 0.5)
	PlayerGui.cutscene_on()
	ScreenAnimations.cutscene_bars_on()
	await get_tree().create_timer(0.5).timeout
	player.position = go_to.position
	await get_tree().create_timer(0.5).timeout
	ScreenAnimations.room_enter(0.0, 0.5)
	PlayerGui.cutscene_off()
	ScreenAnimations.cutscene_bars_off()
	PlayerVars.can_control = true
	player.visible = true
	
	
