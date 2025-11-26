class_name MovingPlatform extends AnimatableBody3D

@export var active: bool = true
@export var move_duration: float = 3.0
@export var move_direction: Direction = Direction.POSITIVE_X
@export_range(1, 100, 1) var move_distance: int = 10

@onready var pause_timer: Timer = $PauseTimer

enum Direction {
	POSITIVE_X,
	NEGATIVE_X,
	POSITIVE_Y,
	NEGATIVE_Y,
	POSITIVE_Z,
	NEGATIVE_Z
}

## true -> moving to destination, false -> returning from destination
var moving_to: bool = false
var start_position: Vector3
var player_touching: bool = false
var last_position: Vector3

func _ready() -> void:
	start_position = global_position
	pause_timer.start()

func move_platform() -> void:
	if !active: return
	
	var tween = create_tween()
	var destination_point: Vector3 = global_position + (move_distance * get_direction_vector())
	
	if moving_to:
		tween.tween_property(self, "global_position", destination_point, move_duration).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.tween_property(self, "global_position", start_position, move_duration).set_ease(Tween.EASE_IN_OUT)
		
	await tween.finished
	pause_timer.start()
	
func get_direction_vector() -> Vector3:
	match move_direction:
		Direction.POSITIVE_X: return Vector3(1, 0, 0)
		Direction.NEGATIVE_X: return Vector3(-1, 0, 0)
		Direction.POSITIVE_Y: return Vector3(0, 1, 0)
		Direction.NEGATIVE_Y: return Vector3(0, -1, 0)
		Direction.POSITIVE_Z: return Vector3(0, 0, 1)
		Direction.NEGATIVE_Z: return Vector3(0, 0, -1)
		_: return Vector3.ZERO

func _physics_process(_delta: float) -> void:
	if player_touching:
		var player: Player = get_tree().get_first_node_in_group("player")
		var marble: Marble = player.marble
		var platform_movement = global_position - last_position
		marble.global_position += platform_movement
		
	last_position = global_position

func _on_pause_timer_timeout() -> void:
	moving_to = !moving_to
	move_platform()

func activate() -> void:
	active = true
	move_platform()

func deactivate() -> void:
	active = false

func one_shot_move() -> void:
	active = true
	move_platform()
	active = false

func _on_marble_detection_area_body_entered(body: Node3D) -> void:
	if body is Marble:
		player_touching = true

func _on_marble_detection_area_body_exited(body: Node3D) -> void:
	if body is Marble:
		player_touching = false
