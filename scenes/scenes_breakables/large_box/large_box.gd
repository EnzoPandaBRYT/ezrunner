extends Enemy

signal enemy_dead

@onready var break_particles = $particles
@onready var health_bar = $health_bar
@onready var anim = $anim
@onready var collisions = $collisions

func _ready() -> void:
	max_health = 4.0
	health = 4.0
	await self.ready
	create_tween().tween_property(anim, "modulate", Color(1.0, 1.0, 1.0), 1)
	health_bar.max_value = max_health
	health_bar.value = max_health
	
func _process(delta: float) -> void:
	if health == 3:
		$anim.frame = 1
	if health == 2:
		$anim.frame = 2
	if health == 1:
		$anim.frame = 3

func _idle() -> void:
	_enterState("idle")

func _dead() -> void:
	_enterState("dead")

func _dead_function():
	var random = randi_range(1,3)
	$shadowlands_tilemap.queue_free()
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	if collisions:
		collisions.queue_free()
	health_bar.visible = false
	_change_state(_StateMachine.DEAD)
	tween.tween_property(anim, "modulate:a", 0.0, 1)
	break_particles.emitting = true
	PlayerStats.torretims_killed += 1
	match random:
		1: 
			$break_sfx_1.pitch_scale = randf_range(0.9,1.0)
			$break_sfx_1.play()
			await $break_sfx_1.finished
		2: 
			$break_sfx_2.pitch_scale = randf_range(0.9,1.0)
			$break_sfx_2.play()
			await $break_sfx_2.finished
		3: 
			$break_sfx_3.pitch_scale = randf_range(0.9,1.0)
			$break_sfx_3.play()
			await $break_sfx_3.finished
	get_tree().queue_delete(self)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	AudioPlayer.punch_sfx(-9)
	var health_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	health -= 1
	health_tween.tween_property(health_bar,"value", health, 0.05)
	anim.modulate = Color(18.892, 18.892, 18.892)
	await get_tree().create_timer(0.1).timeout
	anim.modulate = Color(1.0, 1.0, 1.0, 1.0)
	var tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	if health <= 0:
		_dead_function()
