class_name Player extends Node3D

@onready var level_manager: LevelManager = %LevelManager
@onready var marble: Marble = %Marble
@onready var camera: CameraContainer = %CameraContainer
@onready var trail_3d: Trail3D = $Trail3D

func _ready() -> void:
	global_position = level_manager.current_spawnpoint
	
	level_manager.level_finished.connect(_on_level_finished)

func _physics_process(_delta: float) -> void:
	trail_3d.global_position = marble.global_position

func _on_level_finished() -> void:
	marble.level_finished = true
	marble.can_move = false
	camera.level_finished = true
	camera.smooth_camera_tolerance = 0.1
