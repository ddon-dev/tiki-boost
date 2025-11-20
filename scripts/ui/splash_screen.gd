extends Control

# Scene Transition
@export var scene_transition: Control
@export var wait_fade_out: Timer
@export var splash_sfx: AudioStreamPlayer

func _ready() -> void:
	scene_transition.fade_in()
	
func _on_splash_screen_duration_timeout() -> void:
	scene_transition.fade_out()
	wait_fade_out.start()
	await wait_fade_out.timeout
	StageHandler.go_to_menu()

func _on_splash_screen_sfx_fire_timeout() -> void:
	splash_sfx.play()
