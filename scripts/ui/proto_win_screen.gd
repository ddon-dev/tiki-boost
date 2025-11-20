extends Control

@onready var level_manager: LevelManager = %LevelManager

# Scene Transition
@onready var scene_transition: Control = %SceneTransition

# Audio
@onready var sfx_pressed: AudioStreamPlayer = %ButtonPressedSFX
@onready var victory_jingle: AudioStreamPlayer = %VictoryJingle

# Menus
@export var ask_restart_level: VBoxContainer
@export var ask_return_menu: VBoxContainer
@onready var win_choices: VBoxContainer = %Choices

# Buttons
@onready var restart_button: Button = %RestartButton
@onready var continue_button: Button = %ContinueButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	level_manager.level_finished.connect(_on_level_finished)
	restart_button.pressed.connect(_on_restart_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)

func _on_restart_button_pressed() -> void:
	sfx_pressed.play()
	ask_restart_level.visible = true
	win_choices.visible = false

func _on_continue_button_pressed() -> void:
	sfx_pressed.play()
	await sfx_pressed.finished
	pass

func _on_menu_button_pressed() -> void:
	sfx_pressed.play()
	ask_return_menu.visible = true
	win_choices.visible = false

func _on_level_finished() -> void:
	visible = true
	victory_jingle.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	create_tween().tween_property(self, "modulate:a", 1.0, 0.75)
