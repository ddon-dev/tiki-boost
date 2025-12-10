extends Control

# Bools
@onready var paused: bool = false

# Audio
@onready var sfx_paused: AudioStreamPlayer = %PausePressedSFX
@onready var sfx_pressed: AudioStreamPlayer = %ButtonPressedSFX

# Scene Transition

# Menus
@onready var init_menu: VBoxContainer = %PauseMenu
@onready var menu_options: VBoxContainer = %MenuOptions
@onready var settings_menu: VBoxContainer = %SettingsMenu
@onready var ask_restart_level: VBoxContainer = %AskRestartLevel
@onready var ask_return_menu: VBoxContainer = %AskReturnMenu
@onready var ask_exit_game: VBoxContainer = %AskExitGame
@export var menu_slide: AnimationPlayer
@onready var target_time_anim: AnimationPlayer = $"../HUD/MarginContainer2/TargetTimesAnim"
@onready var target_times_display: HBoxContainer = $"../HUD/MarginContainer2/TargetTimes"

# Buttons
@onready var resume: Button = %Continue
@onready var restart: Button = %RestartLevel
@onready var settings: Button = %Settings
@onready var go_to_menu: Button = %GoToMenu
@onready var exit_game: Button = %ExitGame

func _ready() -> void:
	resume.pressed.connect(resume_game)
	restart.pressed.connect(restart_level)
	settings.pressed.connect(open_settings)
	go_to_menu.pressed.connect(return_menu)
	exit_game.pressed.connect(exit)
	
func _input(event: InputEvent) -> void:
	if GameManager.canPause:
		if event.is_action_pressed("pause") or event.is_action_pressed("cancel"):
			paused = !paused
			sfx_paused.play()
			visible = !visible
			target_time_anim.play("RESET")
			get_tree().paused = !get_tree().paused
		
			if paused:
				AudioServer.set_bus_effect_enabled(1,0,true)
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

			else:
				AudioServer.set_bus_effect_enabled(1,0,false)
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				target_time_anim.play("RESET_OFFSCREEN")
	
func resume_game():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	AudioServer.set_bus_effect_enabled(1,0,false)
	get_tree().paused = !get_tree().paused
	sfx_paused.play()
	target_time_anim.play("RESET_OFFSCREEN")
	visible = !visible
	paused = !paused

func restart_level():
	sfx_pressed.play()
	ask_restart_level.visible = true
	menu_options.visible = false

func open_settings():
	sfx_pressed.play()
	settings_menu.visible = true
	menu_slide.play("slide_left")
	await menu_slide.animation_finished
	init_menu.visible = false

func return_menu():
	sfx_pressed.play()
	ask_return_menu.visible = true
	menu_options.visible = false

func exit():
	sfx_pressed.play()
	ask_exit_game.visible = true
	menu_options.visible = false
