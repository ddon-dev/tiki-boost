extends Button

@onready var trail_color_picker: VBoxContainer = %TrailColorPicker
@onready var v_box_container: VBoxContainer = $".."

func _on_pressed() -> void:
	v_box_container.visible = false
	trail_color_picker.visible = true
