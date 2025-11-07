extends Node3D

@onready var level_manager: LevelManager = %LevelManager

func _on_death_area_body_entered(body: Node3D) -> void:
	if body is Marble:
		var marble: Marble = body
		marble.global_position = level_manager.current_spawnpoint
		marble.reset_position()
