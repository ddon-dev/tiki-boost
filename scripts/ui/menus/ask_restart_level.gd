extends VBoxContainer

# Scene Transition
@onready var scene_transition: Control = %SceneTransition

# Audio
@onready var sfx_pressed: AudioStreamPlayer = %ButtonPressedSFX
#@onready var menu_music: AudioStreamPlayer = %Music

# Menus
@export var menu_options: VBoxContainer


# Buttons
@onready var yes: Button = %ConfirmRestart
@onready var no: Button = %CancelRestart

func _ready() -> void:
	yes.pressed.connect(confirm)
	no.pressed.connect(cancel)
	
func confirm():
	sfx_pressed.play()
	scene_transition.fade_out()
	#menu_music.fade_out()
	await sfx_pressed.finished
	get_tree().paused = false
	StageHandler.restart_level()
	
func cancel():
	sfx_pressed.play()
	visible = !visible
	menu_options.visible = true
