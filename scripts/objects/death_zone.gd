class_name DeathZone extends Node3D

# Audio
@export var sfx_fall: AudioStreamPlayer

@onready var level_manager: LevelManager = %LevelManager

signal deadly_object_touched

func _ready() -> void:
	deadly_object_touched.connect(_deadly_object_touched)

func _on_death_area_body_entered(body: Node3D) -> void:
	if body is Marble:
		_deadly_object_touched()

func _deadly_object_touched() -> void:
	var marble: Marble = get_tree().get_first_node_in_group("player").marble
	sfx_fall.play()
	marble.global_position = level_manager.current_spawnpoint
	marble.reset_position()
