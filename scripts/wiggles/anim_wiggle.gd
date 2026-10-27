extends Node2D

var start_y: float
var time := 0.0
@export var float_speed = 1.0 # Velocidade que os blocos flutuarão.
@export var height_variation = 20 # Variação da altura, para mais e para menos.

func _ready() -> void:
	start_y = position.y

func _process(delta: float) -> void:
	time += delta
	position.y = start_y + sin(time * float_speed) * height_variation
