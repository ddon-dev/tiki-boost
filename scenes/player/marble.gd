class_name Marble extends RigidBody3D

@export var move_speed: float = 1200.0
@export var max_velocity: float = 25.0

@onready var camera: Camera3D = %Camera3D

func _physics_process(delta: float) -> void:
	if abs(linear_velocity.x) - max_velocity > 0.0:
		linear_velocity.x = max_velocity
	if abs(linear_velocity.z) - max_velocity > 0.0:
		linear_velocity.z = -max_velocity
	
	movement(delta)

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
