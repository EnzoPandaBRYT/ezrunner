extends Area2D

var follow_player = false
var acceleration = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position = Vector2(PlayerVars.position_x+30, PlayerVars.position_y+40)
	if follow_player:
		global_position = lerp(global_position, player_position, 2 * delta * acceleration)
		acceleration += 10 * delta


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		PlayerGui.update_health(+5)
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
