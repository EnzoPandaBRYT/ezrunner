extends Area2D

var direction = Vector2.ZERO
var speed := 500.0
var damage := 1

var life_time = 2.0

var can_parry = false

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

func _on_parry_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "player_hitbox":
		direction *= -1
		speed = 500


func _on_area_exited(area: Area2D) -> void:
	can_parry = true
	await get_tree().create_timer(1.0).timeout
	can_parry = false
