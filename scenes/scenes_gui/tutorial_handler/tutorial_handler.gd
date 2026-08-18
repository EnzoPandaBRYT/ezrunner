extends Node2D

@onready var canvas = $canvas/node
@onready var panel = $canvas/node/panel
@onready var label = $canvas/node/panel/label

var tutorial_step = 0

func _ready() -> void:
	$canvas.visible = false
	canvas.modulate.a = 0.0

func tutorial_msg(tutorial_text: String):
	$canvas.visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	label.text = tutorial_text
	panel.size.x = 0
	tween.tween_property(canvas,"modulate:a",1.0,0.5)
	tween.tween_property(panel, "size", Vector2(1921, 312), 0.4)
	tween.tween_property(label, "visible_characters", label.text.length(), 1.0)

func change_text(new_text: String):
	$canvas.visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	label.visible_characters = 0
	label.text = new_text
	tween.tween_property(label, "visible_characters", label.text.length(), 1.0)

func tutorial_msg_end():
	$canvas.visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
	label.text = ""
	tween.tween_property(canvas,"modulate:a",0.0,0.2)
	tween.tween_property(panel, "size", Vector2(0, 312), 0.2)
