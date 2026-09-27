extends Node2D

@onready var canvas = $canvas/node
@onready var panel = $canvas/node/panel
@onready var label = $canvas/node/panel/label

var index = 1

var dialog_active: bool

func _ready() -> void:
	$canvas.visible = false
	canvas.modulate.a = 0.0

func start_dialog(text: String):

	if dialog_active:
		return
	
	index = 1
	label.text = ""
	
	var lines = text.split("\n")
	
	if lines.is_empty():
		dialog_active = false
		return
	
	if !dialog_active:
		new_dialog_window(lines[0])
		PlayerVars.can_control = false
		dialog_active = true
	else:
		return
	
	while index < lines.size():
		if index < lines.size():
			await get_tree().create_timer(4.0).timeout
			change_text(lines[index])
			index += 1
			print("\n INDEX: ", index, "\n " ,lines.size())
	
	dialog_active = false
	
	if index == lines.size():
		await get_tree().create_timer(4.0).timeout
		PlayerVars.can_control = true
		dialog_end()
	

	
func new_dialog_window(dialog_text: String):
	label.text = ""
	if !get_tree().paused:
		$canvas.visible = true
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
		label.text = dialog_text
		tween.tween_property(canvas,"modulate:a",1.0,0.5)
		tween.tween_property(label, "visible_characters", label.text.length(), 1.0)

func change_text(new_text: String):
	label.text = ""
	$canvas.visible = true
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	label.visible_characters = 0
	label.text = new_text
	tween.tween_property(label, "visible_characters", label.text.length(), 1.0)

func dialog_end():
	index = 1
	
	if !get_tree().paused:
		$canvas.visible = true
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel()
		label.text = ""
		tween.tween_property(canvas,"modulate:a",0.0,0.2)
