extends Node2D

signal continue_pressed
signal dialog_finished

@onready var canvas = $canvas/node
@onready var panel = $canvas/node/panel
@onready var label = $canvas/node/panel/label

var text_tween: Tween
var portrait_tween: Tween

var index = 1

var dialog_active: bool
var continue_dialog = false

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
		PlayerGui.cutscene_on()
		ScreenAnimations.cutscene_bars_on()
		PlayerVars.can_control = false
		dialog_active = true
	else:
		return
	
	while index < lines.size():
		await continue_pressed
		change_text(lines[index])
		index += 1
	
	await continue_pressed
	dialog_active = false
	
	if index == lines.size():
		PlayerGui.cutscene_off()
		ScreenAnimations.cutscene_bars_off()
		dialog_end()
		dialog_finished.emit()
		await get_tree().create_timer(0.5).timeout
		PlayerVars.can_control = true
	
func _process(delta: float) -> void:
	if dialog_active and label.visible_characters == label.text.length():
		$canvas/node/portrait/arrow.visible = true
		if Input.is_action_just_pressed("advance_dialog"):
			$canvas/node/portrait/arrow.visible = false
			continue_pressed.emit()
	elif dialog_active and label.visible_characters != label.text.length() and Input.is_action_just_pressed("skip_dialog"):
		text_tween.kill()
		label.visible_characters = label.text.length()
	
func new_dialog_window(dialog_text: String):
	label.text = ""
	if !get_tree().paused:
		$canvas.visible = true
		var random = randi_range(1,2)
		match random:
			1: 
				$sfx.pitch_scale = randf_range(0.9,1.1)
				$sfx.play()
			2:
				$sfx_2.pitch_scale = randf_range(0.9,1.1)
				$sfx_2.play()
		label.text = dialog_text
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
		var portrait_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_parallel(true)
		text_tween = tween
		portrait_tween.tween_property(canvas,"modulate:a",1.0,0.5)
		tween.tween_property(label, "visible_characters", label.text.length(), 1.0)

func change_text(new_text: String):
	if text_tween and text_tween.is_running():
		text_tween.kill()
		
	label.text = ""
	$canvas.visible = true
	label.visible_characters = 0
	label.text = new_text
	
	var random = randi_range(1,2)
	match random:
		1: 
			$sfx.pitch_scale = randf_range(0.9,1.1)
			$sfx.play()
		2:
			$sfx_2.pitch_scale = randf_range(0.9,1.1)
			$sfx_2.play()
	text_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	text_tween.tween_property(label, "visible_characters", label.text.length(), 1.0)

func dialog_end():
	index = 1
	
	if !get_tree().paused:
		$canvas.visible = true
		label.text = ""
		var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
		tween.tween_property(canvas,"modulate:a",0.0,0.2)
		await tween.finished
		$canvas.visible = false

func reset():
		index = 1
		
		dialog_active = false
		label.text = ""
		$canvas.visible = false

func define_name(name: String):
	$canvas/node/name.text = name

func define_portrait(portrait: String):
	$canvas/node/portrait/portrait.animation = portrait
