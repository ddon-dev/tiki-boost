class_name LevelManager extends Node

@warning_ignore_start("unused_signal")
signal checkpoint_reached(position: Vector3)
signal level_finished

@export_category("Level Data")
@export var level_data: LevelData

# Scene Transition
@onready var scene_transition: Control = $"../UI/SceneTransition"

# Timer
@onready var stopwatch: Stopwatch = $Stopwatch
@onready var target_animation: AnimationPlayer = $"../UI/HUD/MarginContainer2/TargetTimesAnim"
@onready var disp_gold_time: Label = $"../UI/HUD/MarginContainer2/TargetTimes/Panel/MarginContainer/VBoxContainer/GoldTimeDisplay/GoldTime"
@onready var disp_silver_time: Label = $"../UI/HUD/MarginContainer2/TargetTimes/Panel/MarginContainer/VBoxContainer/SilverTimeDisplay/SilverTime"
@onready var disp_bronze_time: Label = $"../UI/HUD/MarginContainer2/TargetTimes/Panel/MarginContainer/VBoxContainer/BronzeTimeDisplay/BronzeTime"

# Medals
const NO_MEDAL = preload("uid://ch4hngf405tw1")
const BRONZE = preload("uid://dxao7mrly8ofl")
const SILVER = preload("uid://betwq3un6qvv5")
const GOLD = preload("uid://djcph6dppquhy")

const START_ACTIONS = [
	"forward",
	"backward",
	"left",
	"right",
	 "jump"
]

var current_spawnpoint: Vector3 = Vector3.ZERO

func _ready() -> void:
	get_tree().paused = false
	GameManager.canPause = true
	StageHandler.current_level = level_data
	GameManager.play_music()
	AudioServer.set_bus_effect_enabled(1,0,false)
	current_spawnpoint = $"../SpawnPosition".global_position
	scene_transition.fade_in()
	checkpoint_reached.connect(_checkpoint_reached)
	level_finished.connect(_level_finished)
	disp_gold_time.text = "%s" % get_time_formatted(level_data.gold_medal_time)
	disp_silver_time.text = "%s" % get_time_formatted(level_data.silver_medal_time)
	disp_bronze_time.text = "%s" % get_time_formatted(level_data.bronze_medal_time)
 
func _checkpoint_reached(position: Vector3) -> void:
	current_spawnpoint = position

func _level_finished() -> void:
	var final_time: float = stopwatch.get_time_seconds()
	var current_level_path: String = level_data.level_path
	stopwatch.stop()
	target_animation.play("slide_back")
	SaveManager.update_highscore(current_level_path, final_time)
	
func _process(_delta: float) -> void:
	if stopwatch.running:
		var time_label: Label = $"../UI/HUD/MarginContainer/Timer/TimeLabel"
		var medal: TextureRect = $"../UI/HUD/MarginContainer/Timer/TimeMedal"
		time_label.text = stopwatch.get_time_formatted()
		if stopwatch.elapsed_time <= level_data.gold_medal_time:
			medal.texture = GOLD
		elif stopwatch.elapsed_time <= level_data.silver_medal_time:
			medal.texture = SILVER
		elif stopwatch.elapsed_time <= level_data.bronze_medal_time:
			medal.texture = BRONZE
		else:
			medal.texture = NO_MEDAL
		return
	
	if stopwatch.ended_level == false:
		for action in START_ACTIONS:
			if Input.is_action_pressed(action):
				stopwatch.start()
				target_animation.play("slide_away")

func play_animation():
	target_animation.play("slide_away")

func get_time_formatted(elapsed_time: float) -> String:
	var total_seconds: int = int(elapsed_time)
	@warning_ignore_start("integer_division")
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	var milliseconds: int = int((elapsed_time - total_seconds) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
