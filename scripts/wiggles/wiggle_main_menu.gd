extends Sprite2D

var start_y: float
var start_x: float
var time := 0.0
var float_speed = 1.0 # Velocidade que os blocos flutuarão.
var height_variation = 20 # Variação da altura, para mais e para menos.

func _ready() -> void:
	start_y = global_position.y
	start_x = global_position.x
	
func _process(delta: float) -> void:
	time += delta
	global_position.y = start_y + get_global_mouse_position().y/50 + sin(time * float_speed) * height_variation
	global_position.x = start_x + get_global_mouse_position().x/50
