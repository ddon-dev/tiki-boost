class_name FinishPoint extends Node3D

@onready var level_manager: LevelManager = %LevelManager

func _on_finish_area_body_entered(body: Node3D) -> void:
	if body is Marble:
		level_manager.level_finished.emit()
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
