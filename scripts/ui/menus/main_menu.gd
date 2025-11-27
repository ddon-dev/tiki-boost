extends Control

# Scene Transition
@export var scene_transition: Control

# Audio
#@onready var menu_music: AudioStreamPlayer = %Music
@export var sfx_pressed: AudioStreamPlayer

# Menus
@onready var init_menu: VBoxContainer = %InitMenu
@onready var settings_menu: VBoxContainer = %SettingsMenu
@onready var levels_menu: VBoxContainer = %LevelSelectMenu
@export var menu_slide: AnimationPlayer

# Buttons
@onready var start: Button = %StartGame
@onready var level_select: Button = %LevelSelect
@onready var customize: Button = %Customize
@onready var settings: Button = %Settings
@onready var exit: Button = %ExitGame

func _ready() -> void:
	get_tree().paused = false
	AudioServer.set_bus_effect_enabled(1,0,false)
	scene_transition.fade_in()
	MusicManager.play_menu_music()
	#menu_music.play()
	#menu_music.fade_in()
	start.pressed.connect(start_game)
	level_select.pressed.connect(select_level)
	customize.pressed.connect(customize_options)
	settings.pressed.connect(open_settings)
	exit.pressed.connect(exit_game)

func start_game():
	sfx_pressed.play()
	scene_transition.fade_out()
	#menu_music.fade_out()
	await sfx_pressed.finished
	StageHandler.go_to_init_level()

func select_level():
	sfx_pressed.play()
	levels_menu.visible = true
	menu_slide.play("slide_left")

func customize_options():
	sfx_pressed.play()

func open_settings():
	sfx_pressed.play()
	settings_menu.visible = true
	menu_slide.play("slide_left")
	await menu_slide.animation_finished
	init_menu.visible = false

func exit_game():
	sfx_pressed.play()
	scene_transition.fade_out()
	#menu_music.fade_out()
	await sfx_pressed.finished
	get_tree().quit()
