extends ColorPicker


# SFX
@export var sfx_pressed: AudioStreamPlayer

func _ready() -> void:
	color = GameManager.player_customization.trail_color


func _on_color_changed(new_color: Color) -> void:
	GameManager.player_customization.trail_color = new_color
	PlayerMaterials.trail_color_changed.emit()
