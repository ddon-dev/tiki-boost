extends VBoxContainer

# SFX
@export var sfx_pressed: AudioStreamPlayer

# Button
@onready var apply: Button = %Apply
@onready var reset: Button = %Reset
@onready var default: Button = %Default
@onready var return_menu: Button = %CustomizeReturn

# Menus
@onready var skins_menu: VBoxContainer = %SkinsMenu


func _ready() -> void:
	apply.pressed.connect(apply_settings)
	reset.pressed.connect(previous_settings)
	default.pressed.connect(default_settings)


func apply_settings():
	sfx_pressed.play()
	GameManager.save_current_customization()
	visible = false
	skins_menu.visible = true
	return_menu.visible = true
	
func previous_settings():
	GameManager.load_settings()
	sfx_pressed.play()
	pass

func default_settings():
	GameManager.set_default_trail_color()
	sfx_pressed.play()
	pass
