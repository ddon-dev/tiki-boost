extends VBoxContainer

# Audio
@export var sfx_pressed: AudioStreamPlayer
@onready var menu_music: AudioStreamPlayer = %Music

# Scene Transition
@export var scene_transition: Control

# Menus
@onready var init_menu: VBoxContainer = %InitMenu
@onready var level_menu: VBoxContainer = %LevelSelectMenu
@onready var levels_container: GridContainer = %LevelsContainer
@export var menu_slide: AnimationPlayer

# Buttons
@onready var return_menu: Button = %Return


func _ready() -> void:
	return_menu.pressed.connect(go_back)
	var level_number: int = 1
	var tut_number: int = 1
	for level_path in StageHandler.levels:
		var button = Button.new()
		if level_path.is_tutorial:
			button.text = "Tutorial %s" % tut_number
			tut_number += 1
		else:
			button.text = "Level %s" % level_number
			level_number += 1
		button.flat = true
		levels_container.add_child(button)
		button.pressed.connect(func():
			sfx_pressed.play()
			scene_transition.fade_out()
			menu_music.fade_out()
			await sfx_pressed.finished
			StageHandler.go_to_level(level_path)
		)

func go_back():
	sfx_pressed.play()
	init_menu.visible = true
	menu_slide.play("slide_right")
	await menu_slide.animation_finished
	level_menu.visible = false
