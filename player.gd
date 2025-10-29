class_name Player
extends CharacterBody3D

@export var base_speed: float = 10.0
@export var sprint_speed: float = 15.0
@export var jump_velocity: float = 4.5
@export var rotation_speed: float = 0.2
@export var ball_radius: float = 0.5
var current_speed: float

@onready var ball_mesh: MeshInstance3D = $BallMesh

func _ready() -> void:
	current_speed = base_speed

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta * 1.5
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_pressed("sprint") && is_on_floor():
		current_speed = sprint_speed
	elif Input.is_action_just_released("sprint"):
		current_speed = base_speed
	
	var input_dir := Input.get_vector("left", "right", "forward", "backwards")
	var move_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if move_dir != Vector3.ZERO:
		velocity.x = move_dir.x * current_speed
		velocity.z = move_dir.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()

	# --- ROTATION LOGIC STARTS HERE ---
	# We'll rotate the visible ball, not the collision body.

	# 1. Get horizontal velocity actually being used this frame
	var horizontal_velocity: Vector3 = Vector3(velocity.x, 0.0, velocity.z)
	var speed: float = horizontal_velocity.length()

	if speed > 0.001:
		# 2. Make the ball FACE the movement direction (yaw only)
		#
		# We want the mesh's -Z (Godot forward) to point where we're moving.
		# So we create a basis looking in that direction.
		var facing_dir := horizontal_velocity.normalized()
		var up := Vector3.UP
		var new_basis := Basis.looking_at(facing_dir, up)
		
		# Keep only yaw so the ball doesn't tilt upward/downward
		var current_rot := ball_mesh.rotation
		var target_rot_y := new_basis.get_euler().y
		# Smooth turn
		current_rot.y = lerp_angle(current_rot.y, target_rot_y, rotation_speed * delta)
		ball_mesh.rotation = current_rot

		# 3. Make it ROLL according to distance traveled
		#
		# Physics of rolling without slipping:
		# angular_speed (rad/s) = linear_speed / radius
		#
		# We rotate around an axis perpendicular to the movement direction, in the ground plane.
		# Axis = cross(up, move_dir). This gives the "right" axis to spin around.
		var roll_axis := up.cross(facing_dir).normalized()
		var angular_speed := speed / ball_radius            # rad/sec
		var angle_step := angular_speed * delta             # radians this frame

		# Apply incremental rotation around roll_axis.
		# We'll rotate *in local space of the mesh*.
		ball_mesh.rotate_object_local(roll_axis, angle_step)
