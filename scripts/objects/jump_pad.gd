class_name JumpPad extends Node3D

@export_range(800.0, 3000.0, 100.0) var jump_force: float = 800.0
@export var sfx_activate: AudioStreamPlayer

func _on_jump_pad_area_body_entered(body: Node3D) -> void:
	print("Signal triggered")
	if body is Marble:
		sfx_activate.play()
		var marble: Marble = body as Marble
		marble.apply_jump_boost(jump_force)
