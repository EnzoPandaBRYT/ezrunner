extends Node2D

@export var player: Character
@export var impulse_velocity: int

var can_interact = false
var interacted_once = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if can_interact and Input.is_action_just_pressed("jump"):
		can_interact = false
		player.velocity.y = impulse_velocity
		AudioPlayer.jump_sfx()

func _on_player_detection_body_entered(body: Node2D) -> void:
	can_interact = true

func _on_player_detection_body_exited(body: Node2D) -> void:
	can_interact = false
