class_name LevelManager extends Node

@warning_ignore_start("unused_signal")
signal checkpoint_reached(position: Vector3)
signal level_finished

var current_spawnpoint: Vector3 = Vector3.ZERO

func _ready() -> void:
	current_spawnpoint = $"../SpawnPosition".global_position
	
	checkpoint_reached.connect(_checkpoint_reached)
 
func _checkpoint_reached(position: Vector3) -> void:
	current_spawnpoint = position

# Lógica del reloj del nivel, puntaje
