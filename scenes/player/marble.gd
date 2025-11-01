class_name Marble extends RigidBody3D

@export var move_speed: float = 800.0
@export var max_velocity: float = 20.0
@export var jump_force: float = 7.5
@export var finish_decel: float = 0.25

@onready var camera: Camera3D = %Camera3D

@warning_ignore("unused_signal")
signal entered_level_finish_point

var grounded: bool
var can_move: bool = true
var level_finished: bool = false

func _physics_process(delta: float) -> void:
	if can_move: 
		movement(delta)
	
	if level_finished: gravity_scale = move_toward(gravity_scale, 0.0, finish_decel * delta)
	
	if abs(linear_velocity.x) - max_velocity > 0.0:
		linear_velocity.x = max_velocity
	if abs(linear_velocity.z) - max_velocity > 0.0:
		linear_velocity.z = -max_velocity
	
	if Input.is_action_just_pressed("jump") && grounded:
		jump()

func movement(delta: float) -> void:
	# f_input o forward_input, movimiento hacia adelante y hacia atrás
	var f_input = (Input.get_action_raw_strength("backward") -  Input.get_action_raw_strength("forward"))
	# h_input o horizontal_input, movimiento hacia los lados
	var h_input = (Input.get_action_raw_strength("right") -  Input.get_action_raw_strength("left"))
	
	var camera_transform = camera.get_camera_transform()
	var relative_camera_direction_z = camera_transform.basis.z.normalized()
	var relative_camera_direction_x = camera_transform.basis.x.normalized()
	
	var f_direction = f_input * relative_camera_direction_z
	var h_direction = h_input * relative_camera_direction_x
	
	apply_central_force(f_direction * move_speed * delta)
	apply_central_force(h_direction * move_speed * delta)

func jump() -> void:
	apply_central_impulse(Vector3.UP * jump_force)

func on_level_finish_point() -> void:
	level_finished = true
	can_move = false
