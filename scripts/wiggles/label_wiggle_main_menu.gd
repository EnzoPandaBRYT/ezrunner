extends Label

var start_y: float
var start_x: float
var time := 0.0
var float_speed = 1.0 # Velocidade que os blocos flutuarão.
var height_variation = 20 # Variação da altura, para mais e para menos.

func _ready() -> void:
	start_y = global_position.y
	start_x = global_position.x
	beat()
	color()

func _process(delta: float) -> void:
	time += delta
	global_position.y = start_y + get_global_mouse_position().y/50 + sin(time * float_speed) * height_variation
	global_position.x = start_x + get_global_mouse_position().x/50

func beat():
	while true:
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "scale", Vector2(1.08, 1.08), 0.08)
		tween.tween_property(self, "scale", Vector2.ONE, 0.20)

		await get_tree().create_timer(60.0 / 86.0).timeout

func color():
	while true:
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(self, "theme_override_colors/font_color", Color(0.727, 0.753, 0.937, 1.0), 0.08)
		tween.tween_property(self, "theme_override_colors/font_color", Color(1.0, 1.0, 1.0, 1.0), 0.20)
		
		await get_tree().create_timer((60.0 / 86.0)*4).timeout
