extends Area2D

@onready var particles = $particles

var follow_player = false
var acceleration = 1.0
var heal = 0

func _ready() -> void:
	
	heal = randi_range(3,5)
	match heal:
		3: particles.global_scale = Vector2(0.05, 0.05)
		4: particles.global_scale = Vector2(0.75, 0.75)
		5: particles.global_scale = Vector2(1.5, 1.5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position = Vector2(PlayerVars.position_x+35, PlayerVars.position_y+40)
	if follow_player:
		global_position = lerp(global_position, player_position, 2 * delta * acceleration)
		acceleration += 15 * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		PlayerGui.update_health(+heal)
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		$particles.emitting = false
		await tween.finished
		queue_free()


func _on_detection_body_entered(body: Node2D) -> void:
	if body.name == "player":
		follow_player = true

func _on_detection_body_exited(body: Node2D) -> void:
	if body.name == "player":
		follow_player = false
