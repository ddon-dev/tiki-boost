class_name Player extends Node3D

@onready var level_manager: LevelManager = %LevelManager
@onready var marble: Marble = %Marble
@onready var camera: CameraContainer = %CameraContainer

func _ready() -> void:
	level_manager.current_spawnpoint = global_position
	
	level_manager.level_finished.connect(_on_level_finished)

func _on_level_finished() -> void:
	marble.level_finished = true
	marble.can_move = false
	camera.level_finished = true
	camera.smooth_camera_tolerance = 0.1
