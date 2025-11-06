class_name CameraContainer extends Node3D

@export_range(10.0, 25.0, 5.0) var v_max: float = 15.0
@export_range(-65.0, -25.0, 5.0) var v_min: float = -45.0
@export_range(0.05, 0.15, 0.005) var h_sensitivity: float = 0.1
@export_range(0.05, 0.15, 0.005) var v_sensitivity: float = 0.1
@export_range(5.0, 45.0, 5.0) var h_accel: float = 15.0
@export_range(5.0, 45.0, 5.0) var v_accel: float = 15.0
@export var smooth_camera_tolerance: float = 0.3
@export var final_rotation_speed: float = 25.0

var cam_h_rotation: float = 0.0
var cam_v_rotation: float = 0.0
var level_finished: bool = false

@onready var marble: RigidBody3D = %Marble
@onready var h_rotation: Node3D = %HRotation
@onready var v_rotation: Node3D = %VRotation

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	global_position = lerp(global_position, marble.get_node("MeshInstance3D").global_position, smooth_camera_tolerance)
	
	cam_v_rotation = clamp(cam_v_rotation, v_min, v_max)
	
	if level_finished:
		# la cámara rota alrededor de la balita en el final del nivel
		h_rotation.rotation_degrees.y = lerp(h_rotation.rotation_degrees.y, h_rotation.rotation_degrees.y + 1, delta * final_rotation_speed)
		v_rotation.rotation_degrees.x = lerp(v_rotation.rotation_degrees.x, 0.0, 2 * delta)
	else:
		# la cámara sigue la balita normalmente
		h_rotation.rotation_degrees.y = lerp(h_rotation.rotation_degrees.y, cam_h_rotation, delta * h_accel)
		v_rotation.rotation_degrees.x = lerp(v_rotation.rotation_degrees.x, cam_v_rotation, delta * v_accel)
	
	rotation_degrees.z = 0

func _input(event: InputEvent) -> void:
	# movimiento de la cámara con el mouse
	if event is InputEventMouseMotion:
		cam_h_rotation += -event.relative.x * h_sensitivity
		cam_v_rotation += -event.relative.y * v_sensitivity
	
	if event is InputEventKey:
		match event.keycode:
			KEY_ESCAPE: Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			KEY_SPACE: Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			_: pass
	
