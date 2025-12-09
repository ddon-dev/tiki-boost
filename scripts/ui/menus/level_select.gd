extends VBoxContainer

# Audio
@export var sfx_pressed: AudioStreamPlayer

# Scene Transition
@export var scene_transition: Control

# Menus
@onready var init_menu: VBoxContainer = %InitMenu
@onready var level_menu: VBoxContainer = %LevelSelectMenu
@onready var levels_container: GridContainer = %LevelsContainer
@onready var high_score_container: GridContainer = %HighScoreContainer
@export var menu_slide: AnimationPlayer

# Buttons
@onready var return_menu: Button = %Return


func _ready() -> void:
	return_menu.pressed.connect(go_back)
	var level_number: int = 1
	var tut_number: int = 1
	for level_path in StageHandler.levels:
		
		# Level Button
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
			await sfx_pressed.finished
			StageHandler.go_to_level(level_path)
		)
		
		# Level Record
		var record: PlayerRecord = SaveManager.get_player_record(level_path.level_path)
		var highscore_seconds: float = record.highscore
		var record_time = Label.new()
		record_time.add_theme_font_size_override("font_size", 35)
		record_time.add_theme_constant_override("shadow_outline_size", 0)
		record_time.add_theme_constant_override("outline_size", 21)
		record_time.custom_minimum_size = Vector2(224, 45)
		record_time.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		if highscore_seconds == 0.0:
			record_time.text = "-- : -- : --"
		else:
			record_time.text = get_time_formatted(highscore_seconds)
		high_score_container.add_child(record_time)

func get_time_formatted(elapsed_time: float) -> String:
	var total_seconds: int = int(elapsed_time)
	@warning_ignore_start("integer_division")
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	var milliseconds: int = int((elapsed_time - total_seconds) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]

func go_back():
	sfx_pressed.play()
	init_menu.visible = true
	menu_slide.play("slide_right")
	await menu_slide.animation_finished
	level_menu.visible = false
