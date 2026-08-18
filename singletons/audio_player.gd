extends AudioStreamPlayer

var ost_player = AudioStreamPlayer.new()

## Music
const thrid_world_start_pt_1 = preload("res://ost_sfx/ost/3d_world/start_pt_1.ogg")
const thrid_world_start_pt_2 = preload("res://ost_sfx/ost/3d_world/start_pt_2.ogg")
const thrid_world_end = preload("res://ost_sfx/ost/3d_world/end.mp3")

# Main Menu
const main_menu_theme = preload("res://ost_sfx/ost/main_menu/lost_potential.ogg")
const main_menu_options_theme = preload("res://ost_sfx/ost/main_menu/lost_potential_options.ogg")
const main_menu_theme_end = preload("res://ost_sfx/ost/main_menu/lost_potential_end.ogg")

# Shadowlands
const _first_tutorial = preload("res://ost_sfx/ost/first_tutorial/tutorial.ogg")

## SFX
const jump_sound = preload("res://ost_sfx/sfx/player/swoosh.mp3")

## Player
const punch_hit = preload("res://ost_sfx/sfx/player/punch_hit.wav")

## Enemies
const enemy_spawn = preload("res://ost_sfx/sfx/enemies/enemy_spawn.wav")
const enemy_death = preload("res://ost_sfx/sfx/enemies/enemy_death.wav")

var fade_tween: Tween


func _play_music_fade(music: AudioStream, actualTime: float, volume := -4.0, fade_time := 1.0):
	# Cancela uma transição anterior, caso exista
	if fade_tween and fade_tween.is_valid():
		fade_tween.kill()

	var old_player: AudioStreamPlayer = null

	if ost_player and is_instance_valid(ost_player):
		old_player = ost_player

	var new_player = AudioStreamPlayer.new()

	new_player.stream = music
	new_player.name = "OST_PLAYER"
	new_player.volume_db = -80.0
	new_player.bus = "OST"

	add_child(new_player)

	new_player.play()
	new_player.seek(actualTime)

	# O novo player passa a ser o atual imediatamente
	ost_player = new_player

	# Se não tinha música anterior
	if old_player == null:
		new_player.volume_db = volume
		return

	# Crossfade
	fade_tween = create_tween().set_parallel(true)
	fade_tween.tween_property(old_player, "volume_db", -10.0, fade_time)
	fade_tween.tween_property(new_player, "volume_db", volume, fade_time)
	await fade_tween.finished

	# Confere se o player ainda existe antes de mexer nele
	if is_instance_valid(old_player):
		old_player.stop()
		old_player.queue_free()

# Music

func main_menu(actualTime: float, fade_time = 1.0):
	_play_music_fade(main_menu_theme, actualTime, -4.0, fade_time)

func main_menu_options(actualTime: float, fade_time = 1.0):
	_play_music_fade(main_menu_options_theme, actualTime, -4.0, fade_time)

func _play_music(music: AudioStream, volume = 0.0, actualTime = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	bus = "OST"
	if ost_player.playing:
		ost_player.stop()
	play()
	seek(actualTime)

func main_menu_end():
	_play_music(main_menu_theme_end, 0.0)

func threed_world_start():
	_play_music(thrid_world_start_pt_1, 0.0)
	await self.finished
	_play_music(thrid_world_start_pt_2, 0.0)

func threed_world_end():
	_play_music(thrid_world_end, 0.0)

func first_tutorial():
	_play_music(_first_tutorial, 0.0)


#------------------------------
func play_FX(stream: AudioStream, volume = 0.0, pitch = 1.0):
	var fx_player = AudioStreamPlayer.new()
	fx_player.stream = stream
	fx_player.name = "FX_PLAYER"
	fx_player.volume_db = volume
	fx_player.bus = "SFX" 
	fx_player.pitch_scale = pitch
	add_child(fx_player)
	fx_player.play()
	
	await fx_player.finished
	
	fx_player.queue_free()

# Player SFX
func jump_sfx():
	play_FX(jump_sound)

func punch_sfx(volume):
	play_FX(punch_hit, volume, randf_range(0.9,1.1))

# Enemy SFX
func enemy_spawn_sfx():
	play_FX(enemy_spawn, -9, randf_range(0.9,1.1))

func enemy_death_sfx():
	play_FX(enemy_death, 0, randf_range(0.9,1.1))

func trans_music(trans_time = 0.5):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", 0, trans_time) # fade out
	
	
func music_reduce(new_volume := -18.0, fade_time := 0.5, pitch = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", new_volume, fade_time) # fade out
	tween.tween_property(self, "pitch_scale", pitch, fade_time)

func music_normal(old_volume := -5.0, fade_time := 0.5, pitch = 1.0):
	var tween = create_tween()
	tween.tween_property(self, "volume_db", old_volume, fade_time) # fade out
	tween.tween_property(self, "pitch_scale", pitch, fade_time)
