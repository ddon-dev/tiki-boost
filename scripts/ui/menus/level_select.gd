extends VBoxContainer

# Audio
@export var sfx_pressed: AudioStreamPlayer

# Scene Transition
@export var scene_transition: Control

# Medals
const NO_MEDAL = preload("uid://ch4hngf405tw1")
const BRONZE = preload("uid://dxao7mrly8ofl")
const SILVER = preload("uid://betwq3un6qvv5")
const GOLD = preload("uid://djcph6dppquhy")

# Menus
@onready var init_menu: VBoxContainer = %InitMenu
@onready var level_menu: VBoxContainer = %LevelSelectMenu
@onready var levels_container: VBoxContainer = %LevelsContainer
@onready var high_score_container: VBoxContainer = %HighScoreContainer
@export var menu_slide: AnimationPlayer

# Buttons
@onready var return_menu: Button = %Return

# Particles
const BRONZE_MEDAL_PARTICLES = preload("uid://w0cjamgqgnqa")
const SILVER_MEDAL_PARTICLES = preload("uid://h6dl01x634ud")
const GOLD_MEDAL_PARTICLES = preload("uid://bhsayiyv3bub6")




func _ready() -> void:
	return_menu.pressed.connect(go_back)
	var level_number: int = 1
	var tut_number: int = 1
	for level_path in StageHandler.levels:
		var record: PlayerRecord = SaveManager.get_player_record(
			level_path.level_path)
			
		# Level Button
		var button = Button.new()
		
		if level_path.is_tutorial:
			button.text = "Tutorial %s" % tut_number
			tut_number += 1
		else:
			button.text = "Level %s" % level_number
			level_number += 1
		button.flat = true
		button.custom_minimum_size = Vector2(0, 48)
		button.pressed.connect(func():
			sfx_pressed.play()
			scene_transition.fade_out()
			await sfx_pressed.finished
			StageHandler.go_to_level(level_path)
		)

		# Level Record
		var highscore_seconds: float = record.highscore
		var record_time = MenuButton.new()
		
		record_time.flat = true
		record_time.custom_minimum_size = Vector2(0, 48)
		if highscore_seconds == 0.0:
			record_time.text = "-- : -- : --"
		else:
			record_time.text = get_time_formatted(highscore_seconds)
		record_time.pressed.connect(func():
			sfx_pressed.play()
		)
		# Goal Time Display
		var popup: PopupMenu = record_time.get_popup()
		var bronze_icon = BRONZE
		var silver_icon = SILVER
		var gold_icon = GOLD

		popup.add_icon_item(gold_icon,
		"%s" % get_time_formatted(level_path.gold_medal_time),
		 -1)
		popup.add_icon_item(silver_icon,
		"%s" % get_time_formatted(level_path.silver_medal_time),
		 -1)
		popup.add_icon_item(bronze_icon,
		"%s" % get_time_formatted(level_path.bronze_medal_time),
		 -1)
		popup.add_theme_constant_override("icon_max_width", 28)
		# Medals
		var medal_particles: PackedScene
		
		match record.medal_achieved:
			0:
				record_time.icon = NO_MEDAL
				medal_particles = null
			1:
				record_time.icon = BRONZE
				medal_particles = BRONZE_MEDAL_PARTICLES
			2:
				record_time.icon = SILVER
				medal_particles = SILVER_MEDAL_PARTICLES
			3:
				record_time.icon = GOLD
				medal_particles = GOLD_MEDAL_PARTICLES
				
		record_time.add_theme_constant_override("hseparation", 20)
		record_time.add_theme_constant_override("icon_max_width", 40)
		
		levels_container.add_child(button)
		high_score_container.add_child(record_time)
		if medal_particles != null:
			var particles_instance: GPUParticles2D = medal_particles.instantiate()
			record_time.add_child(particles_instance)
			particles_instance.set_position(Vector2(25,25))

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
