extends Button

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(85, 750), 2)
