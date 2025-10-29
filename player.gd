class_name Player
extends CharacterBody3D

@export var base_speed: float = 10.0        # velocidad máxima caminando
@export var sprint_speed: float = 15.0      # velocidad máxima en sprint
@export var jump_velocity: float = 4.5
@export var rotation_speed: float = 1.0

@export var ground_accel: float = 30.0      # qué tan rápido acelera en el piso
@export var air_accel: float = 10.0         # opcional: en el aire acelera menos
@export var ground_decel: float = 40.0      # qué tan rápido frena en el piso
@export var air_decel: float = 5.0          # qué tan rápido frena en el aire

var current_speed_cap: float = 10.0         # límite de velocidad actual (walk vs sprint)

@export var ball_radius: float = 0.5
@onready var ball_mesh: MeshInstance3D = $BallMesh

func _physics_process(delta: float) -> void:
	# GRAVEDAD
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	# SALTO
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# SPRINT
	if Input.is_action_pressed("sprint") and is_on_floor():
		current_speed_cap = sprint_speed
	elif Input.is_action_just_released("sprint"):
		current_speed_cap = base_speed
	
	# INPUT DE MOVIMIENTO (X/Z)
	var input_dir := Input.get_vector("left", "right", "forward", "backwards")
	var wish_dir := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# elegimos qué tan fuerte empujamos según suelo/aire
	var accel = ground_accel if is_on_floor() else air_accel
	var decel = ground_decel if is_on_floor() else air_decel

	# ACELERACIÓN
	if wish_dir != Vector3.ZERO:
		var desired_vel: Vector3 = wish_dir * current_speed_cap
		
		velocity.x = move_toward(velocity.x, desired_vel.x, accel * delta)
		velocity.z = move_toward(velocity.z, desired_vel.z, accel * delta)
	else:
		# No hay input entonces frenamos suave hacia 0
		velocity.x = move_toward(velocity.x, 0.0, decel * delta)
		velocity.z = move_toward(velocity.z, 0.0, decel * delta)

	move_and_slide()

	# ROTACIÓN (rota el mesh, no la collision shape)

	# Velocidad horizontal
	var horizontal_velocity: Vector3 = Vector3(velocity.x, 0.0, velocity.z)
	var speed: float = horizontal_velocity.length()

	if speed > 0.001:
		# La balita mira hacia donde se mueve
		var facing_dir := horizontal_velocity.normalized()
		var up := Vector3.UP
		var new_basis := Basis.looking_at(facing_dir, up)
		
		var current_rot := ball_mesh.rotation
		var target_rot_y := new_basis.get_euler().y
		
		current_rot.y = lerp_angle(current_rot.y, target_rot_y, rotation_speed * delta)
		ball_mesh.rotation = current_rot

		# Rota según la distancia
		var roll_axis := up.cross(facing_dir).normalized()
		var angular_speed := speed / ball_radius
		var angle_step := angular_speed * delta

		ball_mesh.rotate_object_local(roll_axis, angle_step)
