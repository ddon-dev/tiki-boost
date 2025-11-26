extends Node3D

# Scene Transition
@export var scene_transition: Control

# Audio
@onready var menu_music: AudioStreamPlayer = %Music


func _ready() -> void:
	get_tree().paused = false
	AudioServer.set_bus_effect_enabled(1,0,false)
	menu_music.fade_in()
