extends Enemy

var follow_player = false

signal enemy_dead

@onready var spawn_particles = $anim/spawn_particles
@onready var death_particles = $death_particles
@onready var health_bar = $health_bar
@onready var anim = $anim
@onready var collisions = $collisions
@onready var batch_hitbox = $collisions/batch_hitbox

func _ready() -> void:
	await self.ready
	AudioPlayer.enemy_spawn_sfx()
	batch_hitbox.monitoring = false
	batch_hitbox.monitorable = false
	$collisions/hurtbox.monitoring = false
	$collisions/follow_player.monitoring = false
	create_tween().tween_property(anim, "modulate", Color(1.0, 1.0, 1.0), 1)
	health_bar.max_value = max_health
	health_bar.value = max_health
	spawn_particles.emitting = true
	await spawn_particles.finished
	batch_hitbox.monitoring = true
	batch_hitbox.monitorable = true
	$collisions/hurtbox.monitoring = true
	$collisions/follow_player.monitoring = true
	

func _idle() -> void:
	_enterState("idle")
	position.y = position.y + sin(Time.get_ticks_msec() / 200.0) * 2
	if follow_player and health > 1:
		_change_state(_StateMachine.CHASE)

func _chase() -> void:
	_enterState("chasing")
	position.y = position.y + sin(Time.get_ticks_msec() / 200.0) * 2
	global_position = global_position.lerp(Vector2(PlayerVars.position_x+randf_range(-10,10), PlayerVars.position_y+50), 0.006)
	
	if !follow_player:
		velocity.x -= 0.1
		if velocity.x <= 0:
			_change_state(_StateMachine.IDLE)

func _dead() -> void:
	_enterState("dead")
	velocity.y = sin(Time.get_ticks_msec() / 200.0) * 80

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
		enemy_dead.emit()
		AudioPlayer.enemy_death_sfx()
		collisions.queue_free()
		health_bar.visible = false
		_change_state(_StateMachine.DEAD)
		create_tween().tween_property(anim, "modulate", Color(2.0, 2.0, 2.0), 0.5)
		tween.tween_property(anim, "modulate:a", 0.0, 1)
		death_particles.emitting = true
		PlayerStats.batchs_killed += 1
		await death_particles.finished
		get_tree().queue_delete(self)


func _on_follow_player_body_entered(body: Node2D) -> void:
	follow_player = true

func _on_follow_player_body_exited(body: Node2D) -> void:
	follow_player = false
