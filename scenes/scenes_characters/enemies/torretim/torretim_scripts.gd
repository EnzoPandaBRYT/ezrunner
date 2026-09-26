extends Enemy

var follow_player = false
var player_inside = false

signal enemy_dead

@onready var spawn_particles = $anim/spawn_particles
@onready var death_particles = $death_particles
@onready var health_bar = $health_bar
@onready var anim = $anim
@onready var collisions = $collisions
@onready var torretim_hitbox = $collisions/torretim_hitbox

var shoot_cooldown := 2.0
var shoot_timer := 0.0

var projectile_scene = preload("res://scenes/scenes_characters/attacks/projectiles/torretim/torretim_projectile.tscn")
var health_drop_scene = preload("res://scenes/scenes_characters/drops/health/health_drop.tscn")

func _ready() -> void:
	max_health = 2.0
	health = 2.0
	await self.ready
	$spawn_sfx.pitch_scale = randf_range(0.5,0.75)
	$spawn_sfx.play()
	torretim_hitbox.monitoring = false
	torretim_hitbox.monitorable = false
	$collisions/hurtbox.monitoring = false
	$collisions/follow_player.monitoring = false
	create_tween().tween_property(anim, "modulate", Color(1.0, 1.0, 1.0), 1)
	health_bar.max_value = max_health
	health_bar.value = max_health
	spawn_particles.emitting = true
	await spawn_particles.finished
	torretim_hitbox.monitoring = true
	torretim_hitbox.monitorable = true
	$collisions/hurtbox.monitoring = true
	$collisions/follow_player.monitoring = true
	
func _process(delta: float) -> void:
	if shoot_timer > 0:
		shoot_timer -= delta

func _idle() -> void:
	_enterState("idle")
	if follow_player and health > 1:
		_change_state(_StateMachine.CHASE)

func _chase() -> void:
	_enterState("chasing")
	var player_position = Vector2(PlayerVars.position_x, PlayerVars.position_y)
	
	if shoot_timer <= 0:
		_shoot()
		shoot_timer = shoot_cooldown
	
	if !follow_player:
		_change_state(_StateMachine.IDLE)

func _shoot():
	$shoot_sfx.pitch_scale = randf_range(0.75,1.0)
	$shoot_sfx.play()
	var projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	var spawn_pos = $anim.global_position
	spawn_pos.y -= 35
	
	var player_position : Vector2
	player_position = Vector2(PlayerVars.position_x, PlayerVars.position_y+30)
	
	if !player_inside:
		projectile.global_position = spawn_pos
		projectile.direction = spawn_pos.direction_to(player_position)
	else:
		var tween = create_tween()
		projectile.global_position = spawn_pos
		tween.tween_property(projectile, "global_position", player_position+Vector2(30.0,0.0), 0.1)

func _dead() -> void:
	_enterState("dead")
	velocity.y -= 20

func _spawn_health(pos: Vector2):
	var health_drop = health_drop_scene.instantiate()
	health_drop.global_position = pos
	get_tree().current_scene.add_child(health_drop)

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
		_spawn_health(global_position)
		enemy_dead.emit()
		AudioPlayer.enemy_death_sfx()
		collisions.queue_free()
		health_bar.visible = false
		_change_state(_StateMachine.DEAD)
		create_tween().tween_property(anim, "modulate", Color(2.0, 2.0, 2.0), 0.5)
		tween.tween_property(anim, "modulate:a", 0.0, 1)
		death_particles.emitting = true
		PlayerStats.torretims_killed += 1
		await death_particles.finished
		get_tree().queue_delete(self)


func _on_follow_player_body_entered(body: Node2D) -> void:
	follow_player = true

func _on_follow_player_body_exited(body: Node2D) -> void:
	follow_player = false


func _on_follow_player_inside_body_entered(body: Node2D) -> void:
	player_inside = true

func _on_follow_player_inside_body_exited(body: Node2D) -> void:
	player_inside = false
