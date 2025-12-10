class_name Checkpoint extends Node3D

@onready var level_manager: LevelManager = %LevelManager
@onready var spawn_position: Marker3D = %SpawnPosition
@onready var check_sfx: AudioStreamPlayer = $CheckSFX

var checkpoint_reached: bool = false

func _on_checkpoint_area_body_entered(body: Node3D) -> void:
	if body is Marble:
		level_manager.checkpoint_reached.emit(spawn_position.global_position)
		if checkpoint_reached == false:
			check_sfx.play()
			checkpoint_reached = true
