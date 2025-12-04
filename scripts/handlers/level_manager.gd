class_name LevelManager extends Node

@warning_ignore_start("unused_signal")
signal checkpoint_reached(position: Vector3)
signal level_finished

@export_category("Level Data")
@export var level_data: LevelData

# Scene Transition
@onready var scene_transition: Control = $"../UI/SceneTransition"
@onready var stopwatch: Stopwatch = $Stopwatch

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
 
func _checkpoint_reached(position: Vector3) -> void:
	current_spawnpoint = position

func _level_finished() -> void:
	stopwatch.stop()

func _process(_delta: float) -> void:
	if stopwatch.running:
		var time_label: Label = $"../UI/HUD/MarginContainer/TimeLabel"
		time_label.text = stopwatch.get_time_formatted()
		return
	
	for action in START_ACTIONS:
		if Input.is_action_just_pressed(action):
			stopwatch.start()

# Lógica del reloj del nivel, puntaje
