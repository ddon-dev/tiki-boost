extends Node3D

@onready var level_manager: LevelManager = %LevelManager

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Marble:
		var marble: Marble = body
		marble.global_position = level_manager.current_spawnpoint
		marble.linear_velocity = Vector3.ZERO
		marble.angular_velocity = Vector3.ZERO
