extends ColorPicker


# SFX
@export var sfx_pressed: AudioStreamPlayer

# Buttons
@onready var default: Button = %Default

func _ready() -> void:
	color = GameManager.player_customization.trail_color
	default.pressed.connect(set_default_color)


func _on_color_changed(new_color: Color) -> void:
	GameManager.player_customization.trail_color = new_color
	PlayerMaterials.trail_color_changed.emit()

func set_default_color():
	color = GameManager.def_color
