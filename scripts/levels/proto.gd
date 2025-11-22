extends Node3D

# Scene Transition
@export var scene_transition: Control

# Audio
@onready var menu_music: AudioStreamPlayer = %Music


func _ready() -> void:
	scene_transition.fade_in()
	menu_music.fade_in()
