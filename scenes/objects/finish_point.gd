extends Node3D

func _on_finish_area_body_entered(body: Node3D) -> void:
	if body.owner.is_in_group("player"):
		body.entered_level_finish_point.emit()
