extends VBoxContainer

# Scene Transition
@onready var scene_transition: Control = %SceneTransition

# Audio
@onready var sfx_pressed: AudioStreamPlayer = %ButtonPressedSFX

# Menus
@export var menu_options: VBoxContainer


# Buttons
@onready var yes: Button = %ConfirmMenu
@onready var no: Button = %CancelMenu

func _ready() -> void:
	yes.pressed.connect(confirm)
	no.pressed.connect(cancel)
	
func confirm():
	sfx_pressed.play()
	scene_transition.fade_out()
	await sfx_pressed.finished
	get_tree().paused = false
	StageHandler.go_to_menu()
	
func cancel():
	sfx_pressed.play()
	visible = !visible
	menu_options.visible = true
