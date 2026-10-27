extends Node2D

@onready var canvas = $canvas/node
@onready var panel = $canvas/node/panel
@onready var label = $canvas/node/panel/label

var tutorial_step = 0

var animation_playing = false

func _ready() -> void:
	$canvas.hide()
	canvas.modulate.a = 0.0

func tutorial_msg(tutorial_text: String):
	if !get_tree().paused:
		animation_playing = true
		$canvas.show()
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
		label.text = tutorial_text
		panel.size.x = 0
		tween.tween_property(canvas,"modulate:a",1.0,0.5)
		tween.tween_property(panel, "size", Vector2(1921, 312), 0.4)
		tween.tween_property(label, "visible_characters", label.text.length(), 1.0)

func change_text(new_text: String):
	if !get_tree().paused:
		animation_playing = true
		$canvas.show()
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		label.visible_characters = 0
		label.text = new_text
		tween.tween_property(label, "visible_characters", label.text.length(), 1.0)

func tutorial_msg_end():
	if !get_tree().paused:
		$canvas.show()
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
		label.text = ""
		tween.tween_property(canvas,"modulate:a",0.0,0.2)
		tween.tween_property(panel, "size", Vector2(0, 312), 0.2)
		await tween.finished
		animation_playing = false

func tutorial_msg_controller(control: String):
	if !get_tree().paused:
		animation_playing = true
		$canvas.show()
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		label.visible_characters = 0
		
		if control == "L3":
			label.text = "Tente se mexer usando       ."
		if control == "JUMP":
			label.text = "Pressione       para pular sobre obstáculos."
		if control == "JUMP_HIGHER":
			label.text = "Você pode SEGURAR       para pular mais alto."
		if control == "PUNCH":
			label.text = "Pressione        para socar esse Batch."
		tween.tween_property(label, "visible_characters", label.text.length(), 1.0)
		await tween.finished
		if control == "L3":
			$canvas/node/panel/L3.show()
		if control == "JUMP":
			$canvas/node/panel/cross.show()
		if control == "JUMP_HIGHER":
			$canvas/node/panel/cross_higher.show()
		if control == "PUNCH":
			$canvas/node/panel/square.show()
		
func hide_controls():
	$canvas/node/panel/L3.hide()
	$canvas/node/panel/cross.hide()
	$canvas/node/panel/cross_higher.hide()
	$canvas/node/panel/square.hide()
