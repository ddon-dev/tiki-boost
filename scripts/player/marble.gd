class_name Marble extends RigidBody3D

@export var move_speed: float = 800.0
@export var max_velocity: float = 20.0
@export var jump_force: float = 7.5
@export var finish_decel: float = 0.25
@export var jump_buffer_window: float = 0.08
@export var coyote_time_window: float = 0.08
@export var boost_default_speed: float = 40.0
@export var boost_default_duration: float = 0.6

@onready var camera: Camera3D = %Camera3D
@onready var ground_check_ray: RayCast3D = %GroundCheckRay

# VFX
@onready var speed_lines: ColorRect = %SpeedLines

# Audio
@onready var sfx_rolling: AudioStreamPlayer3D = %RollingSFX
@onready var sfx_land: AudioStreamPlayer3D = %LandSFX
@export var min_volume: float = 0 # Linear, no db
@export var max_volume: float = 1
@export var min_pitch: float = 0.65
@export var max_pitch: float = 1

var current_velocity: float
var velocity_percent: float
var target_volume_db: float
var target_pitch: float

var is_jumping: bool = false
var can_move: bool = true
var level_finished: bool = false

@onready var jump_buffer_timer: Timer = %JumpBuffer
@onready var coyote_timer: Timer = %Coyote
var coyote_time_active: bool = false

var is_boosted: bool = false
var boost_timer: float = 0.0

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
	
	if is_boosted:
		boost_timer -= delta
		if boost_timer <= 0.0:
			is_boosted = false
	else:
		if abs(linear_velocity.x) > max_velocity:
			linear_velocity.x = sign(linear_velocity.x) * max_velocity
		if abs(linear_velocity.z) > max_velocity:
			linear_velocity.z = sign(linear_velocity.z) * max_velocity
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer.start(jump_buffer_window)
	
	if jump_buffer_timer.time_left > 0.0 && (ground_check_ray.is_colliding() || coyote_time_active):
		_jump()
		
	# Speed Lines
	var density = linear_velocity.length() * 0.030
	speed_lines.material.set_shader_parameter("line_density", density)
	
	# SFX
	var is_grounded: bool = ground_check_ray.is_colliding()
	current_velocity = linear_velocity.length()
	velocity_percent = clamp(inverse_lerp(0.0, max_velocity, current_velocity), 0.0, 1.0)
	target_volume_db = lerp(min_volume, max_volume, velocity_percent)
	target_pitch = lerp(min_pitch, max_pitch, velocity_percent)
		
	sfx_rolling.volume_db = linear_to_db(target_volume_db)
	sfx_rolling.pitch_scale = target_pitch

	if is_grounded:
		if not sfx_rolling.playing and current_velocity > 0.1:
			sfx_rolling.play()
		elif sfx_rolling.playing and current_velocity <= 0.1:
			pass
	else:
		if sfx_rolling.playing:
			sfx_rolling.stop()
			sfx_rolling.volume_db = linear_to_db(0.0)

func _on_body_entered(_body: Node) -> void:
	sfx_land.volume_db = linear_to_db(target_volume_db)
	if not sfx_land.is_playing():
		sfx_land.play()

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

func apply_speed_boost(direction: Vector3, speed: float, duration: float) -> void:
	is_boosted = true
	boost_timer = duration

	var dir := direction.normalized()
	if dir == Vector3.ZERO:
		return

	# Mantenemos la velocidad vertical actual para no matar saltos
	var vy := linear_velocity.y
	var new_vel := dir * speed
	new_vel.y = vy

	linear_velocity = new_vel

func _jump() -> void:
	is_jumping = true
	coyote_time_active = false
	set_axis_velocity(Vector3.UP * jump_force)

func reset_position() -> void:
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
