extends Node2D

@onready var gui = $canvas/canvas
@onready var health_bar = $canvas/canvas/health_bar

func level_start():
	gui.modulate.a = 0.0

func cutscene_on():
	var cut = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	cut.tween_property(gui, "modulate:a", 0.0, 1)
	cut.tween_property(gui, "global_position", Vector2(0,-90), 1)

func cutscene_off():
	var cut = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	cut.tween_property(gui, "modulate:a", 1.0, 1)
	cut.tween_property(gui, "position", Vector2(0,0), 1)

func update_health(new_value: float):
	var health = create_tween().set_parallel(true).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	if PlayerVars.player_health >= 0 and PlayerVars.player_health < 100:
		PlayerVars.player_health += new_value
		health.tween_property(health_bar,"value", PlayerVars.player_health, 0.2)
	if PlayerVars.player_health < 0.0:
		PlayerVars.player_health = 0.0
	if PlayerVars.player_health > PlayerVars.player_max_health:
		PlayerVars.player_health = PlayerVars.player_max_health
	print(PlayerVars.player_health)
