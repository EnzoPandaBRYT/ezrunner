extends Area2D

var direction = Vector2.ZERO
var speed := 400.0
var damage := 1

var life_time = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	global_position += direction * delta * speed
	if life_time > 0:
		life_time -= delta
	if life_time <= 0:
		life_time = 9999
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 1)
		await tween.finished
		queue_free()
	
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		var tween = create_tween()
		PlayerGui.update_health(-4)
		tween.tween_property(self, "modulate:a", 0.0, 0.5)
		$particles.emitting = false
		$sprite.visible = false
		direction = Vector2.ZERO
		await tween.finished
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area.name == "player_hitbox":
		print("Parry")
