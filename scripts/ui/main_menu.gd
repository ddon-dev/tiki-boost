extends Control

# Scene Transition
@export var scene_transition: Control

# Audio
@export var menu_music: AudioStreamPlayer
@export var sfx_pressed: AudioStreamPlayer

# Menus
@onready var init_menu: VBoxContainer = %InitMenu
@onready var settings_menu: VBoxContainer = %SettingsMenu

# Buttons
@onready var start: Button = %StartGame
@onready var level_select: Button = %LevelSelect
@onready var customize: Button = %Customize
@onready var settings: Button = %Settings
@onready var exit: Button = %ExitGame

func _ready() -> void:
	get_tree().paused = false
	scene_transition.fade_in()
	menu_music.play()
	menu_music.fade_in()
	start.pressed.connect(start_game)
	level_select.pressed.connect(select_level)
	customize.pressed.connect(customize_options)
	settings.pressed.connect(open_settings)
	exit.pressed.connect(exit_game)

func start_game():
	sfx_pressed.play()
	scene_transition.fade_out()
	menu_music.fade_out()
	await sfx_pressed.finished
	StageHandler.go_to_init_level()

func select_level():
	sfx_pressed.play()

func customize_options():
	sfx_pressed.play()

func open_settings():
	sfx_pressed.play()
	settings_menu.visible = true
	init_menu.visible = false

func exit_game():
	sfx_pressed.play()
	scene_transition.fade_out()
	menu_music.fade_out()
	await sfx_pressed.finished
	get_tree().quit()
