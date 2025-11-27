class_name LevelManager extends Node

@warning_ignore_start("unused_signal")
signal checkpoint_reached(position: Vector3)
signal level_finished

@export_category("Level Data")
@export var level_data: LevelData

# Scene Transition
@onready var scene_transition: Control = %SceneTransition

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
 
func _checkpoint_reached(position: Vector3) -> void:
	current_spawnpoint = position

# Lógica del reloj del nivel, puntaje
