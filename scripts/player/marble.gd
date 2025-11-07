class_name Marble extends RigidBody3D

@export var move_speed: float = 800.0
@export var max_velocity: float = 20.0
@export var jump_force: float = 7.5
@export var finish_decel: float = 0.25
@export var jump_buffer_window: float = 0.08
@export var coyote_time_window: float = 0.08

@onready var camera: Camera3D = %Camera3D
@onready var ground_check_ray: RayCast3D = %GroundCheckRay

var is_jumping: bool = false
var can_move: bool = true
var level_finished: bool = false

@onready var jump_buffer_timer: Timer = %JumpBuffer
@onready var coyote_timer: Timer = %Coyote
var coyote_time_active: bool = false

func _ready() -> void:
	coyote_timer.timeout.connect(func(): coyote_time_active = false)

func _physics_process(delta: float) -> void:
	#%JumpBufferLabel.text = "jump_buffer == %0.2f" % jump_buffer_timer.time_left
	#%CoyoteLabel.text = "coyote_timer == %0.2f" % coyote_timer.time_left
	#%JumpBoolLabel.text = "is_jumping == %s" % is_jumping

	if ground_check_ray.is_colliding():
		if is_jumping: is_jumping = false
	else: 
		if !is_jumping && !coyote_time_active: 
			coyote_timer.start(coyote_time_window)
			coyote_time_active = true
	
	ground_check_ray.global_position = global_position
	ground_check_ray.force_raycast_update()
	
	if can_move: 
		_movement(delta)
	
	if level_finished: gravity_scale = move_toward(gravity_scale, 0.0, finish_decel * delta)
	
	if abs(linear_velocity.x) - max_velocity > 0.0:
		linear_velocity.x = max_velocity
	if abs(linear_velocity.z) - max_velocity > 0.0:
		linear_velocity.z = -max_velocity
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start(jump_buffer_window)
	
	if jump_buffer_timer.time_left > 0.0 && (ground_check_ray.is_colliding() || coyote_time_active):
		_jump()

func _movement(delta: float) -> void:
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

func _jump() -> void:
	is_jumping = true
	coyote_time_active = false
	set_axis_velocity(Vector3.UP * jump_force)

func reset_position() -> void:
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
