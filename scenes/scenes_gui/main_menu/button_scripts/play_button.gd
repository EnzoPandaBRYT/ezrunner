extends Button

func _ready() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(85,350), 1)
