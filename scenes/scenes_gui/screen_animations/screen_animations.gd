extends Node2D

@onready var white_rect = $white_rect/canvas/color_rect
@onready var black_rect = $black_rect/canvas/color_rect

## Cutscene Bars
@onready var black_rect_up = $black_bars/canvas/color_rect_up
@onready var black_rect_bottom = $black_bars/canvas/color_rect_bottom

var animation_playing = false

func _ready() -> void:
	white_rect.modulate.a = 0.0
	black_rect.modulate.a = 0.0
	
func white_fade(alpha:= 1.0, duration:= 0.5):
	animation_playing = true
	var tween = get_tree().create_tween()
	white_rect.visible = true
	tween.tween_property(white_rect, "modulate:a", alpha, duration)
	await tween.finished
	animation_playing = false
	
func black_fade(alpha:= 1.0, duration:= 0.5):
	animation_playing = true
	var tween = get_tree().create_tween()
	black_rect.visible = true
	tween.tween_property(black_rect, "modulate:a", alpha, duration)
	await tween.finished
	animation_playing = false

func room_enter(alpha:= 0.0, duration:= 0.5):
	animation_playing = true
	var tween = get_tree().create_tween()
	black_rect.visible = true
	black_rect.modulate.a = 1.0
	tween.tween_property(black_rect, "modulate:a", alpha, duration)
	await get_tree().create_timer(duration).timeout
	black_rect.visible = false
	await tween.finished
	animation_playing = false
	

func cutscene_bars_on(duration:= 0.5):
	animation_playing = true
	var tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	black_rect_up.visible = true
	black_rect_bottom.visible = true
	tween.tween_property(black_rect_up, "position:y", 0, duration)
	tween.tween_property(black_rect_bottom, "position:y", 1005, duration)
	await tween.finished
	animation_playing = false

func cutscene_bars_off(duration:= 0.5):
	animation_playing = true
	var tween = get_tree().create_tween().set_parallel(true).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(black_rect_up, "position:y", -75, duration)
	tween.tween_property(black_rect_bottom, "position:y", 1080, duration)
	await tween.finished
	animation_playing = false
	
func reset():
	cutscene_bars_off()
