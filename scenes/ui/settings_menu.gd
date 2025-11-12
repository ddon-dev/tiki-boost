extends VBoxContainer

# Audio
@export var sfx_pressed: AudioStreamPlayer

# Menus
@export var prev_menu: VBoxContainer
@onready var settings_menu: VBoxContainer = %SettingsMenu

# Buttons
@onready var apply: Button = %ApplySettings
	
func _ready() -> void:
	apply.pressed.connect(apply_options)
	
func apply_options():
	sfx_pressed.play()
	prev_menu.visible = true
	settings_menu.visible = false
	#GameManager.save_settings()
