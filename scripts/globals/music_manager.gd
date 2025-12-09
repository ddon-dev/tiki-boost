extends AudioStreamPlayer

# Fade In/Out (add later)
@export_category("Fade In/Out Times")
@export var fade_in_target: float
@export var fade_in_time: float
@export var fade_out_time: int

# Level's Music
@export_category("Music Manager")
@export var menu_music: AudioStream
@export var tutorial_music: AudioStream
@export var level_music_1: AudioStream
@export var level_music_2: AudioStream

func play_tutorial_music():
	if stream != tutorial_music:
		stream = tutorial_music
		play()

func play_level_music_1():
	if stream != level_music_1:
		stream = level_music_1
		play()
		
func play_level_music_2():
	if stream != level_music_2:
		stream = level_music_2
		play()

func play_menu_music():
	if stream != menu_music:
		stream = menu_music
		play()
		
func stop_music():
	stop()

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
