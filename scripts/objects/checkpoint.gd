class_name Checkpoint extends Node3D

@onready var level_manager: LevelManager = %LevelManager
@onready var spawn_position: Marker3D = %SpawnPosition

func _on_checkpoint_area_body_entered(body: Node3D) -> void:
	if body is Marble:
		level_manager.checkpoint_reached.emit(spawn_position.global_position)
