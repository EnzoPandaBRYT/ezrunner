extends Node2D

@onready var thunder = $line
@onready var thunder_hitbox = $thunder_hitbox
@onready var collision = $thunder_hitbox/collision

func invoke_thunder(pos: Vector2):
	AudioPlayer.thunder_charge_sfx()
	self.position = pos
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_method(set_line_point_1, Vector2(0,0), thunder.points[1], 0.5)
	
	for i in range(2):
		var more_a = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		more_a.tween_property(self, "modulate:a", 0.5, 0.25)
		await more_a.finished
		
		var less_a = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		less_a.tween_property(self, "modulate:a", 0.25, 0.25)
		await less_a.finished
	
	AudioPlayer.thunder_release_sfx()
	thunder_hitbox.monitorable = true
	thunder_hitbox.monitoring = true
	collision.disabled = false
	self.modulate.a = 1.0
	await get_tree().create_timer(0.5).timeout
	var shrink = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	shrink.tween_method(set_line_point_1, thunder.points[1], Vector2(0,0), 0.75)
	thunder_hitbox.monitorable = false
	thunder_hitbox.monitoring = false
	collision.disabled = true
	await get_tree().create_timer(0.75).timeout
	queue_free()
	
func set_line_point_1(pos: Vector2) -> void:
	var points = thunder.points
	points[1] = pos
	thunder.points = points
