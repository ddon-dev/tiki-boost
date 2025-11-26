extends AudioStreamPlayer

# Fade In/Out (add later)
@export_category("Fade In/Out Times")
@export var fade_in_target: float
@export var fade_in_time: float
@export var fade_out_time: int

# Level's Music
@export_category("Level's Music")
@export var tutorial_music: AudioStream
@export var orange_levels_music: AudioStream

func play_tutorial_music():
	if stream != tutorial_music:
		stream = tutorial_music
		play()

func play_orange_levels_music():
	if stream != orange_levels_music:
		stream = orange_levels_music
		play()

func fade_in():
	create_tween().tween_property(
		self,
		"volume_linear",
		fade_in_target,
		fade_in_time
	)
	
func fade_out():
	create_tween().tween_property(
		self,
		"volume_db",
		-150,
		fade_out_time
	)
