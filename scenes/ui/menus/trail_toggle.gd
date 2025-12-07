extends CheckButton


func _ready() -> void:
	button_pressed = GameManager.player_customization.trail_enabled

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GameManager.player_customization.trail_enabled = true
		GameManager.save_current_customization()
	else:
		GameManager.player_customization.trail_enabled = false
		GameManager.save_current_customization()
