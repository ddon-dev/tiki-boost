@tool class_name Stopwatch extends Node

var elapsed_time: float = 0.0
var running: bool = false
var ended_level: bool = false

var personal_best: Vector3 = Vector3.ZERO

func _process(delta: float) -> void:
	if running && !ended_level:
		elapsed_time += delta

func start() -> void:
	if !ended_level: running = true

func stop() -> void:
	running = false
	ended_level = true
	#personal_best = Vector3(minutes, seconds, milliseconds)

func reset() -> void:
	elapsed_time = 0.0

func restart() -> void:
	elapsed_time = 0.0
	running = true

func get_time_seconds() -> float:
	return elapsed_time

func get_time_formatted() -> String:
	var total_seconds: int = int(elapsed_time)
	@warning_ignore_start("integer_division")
	var minutes: int = total_seconds / 60
	var seconds: int = total_seconds % 60
	var milliseconds: int = int((elapsed_time - total_seconds) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds]
