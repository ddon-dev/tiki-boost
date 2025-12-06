extends Area3D

@export var orbit_speed: float = 15.0

var bodies: Array[RigidBody3D] = []

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body is RigidBody3D:
		bodies.append(body)
		
		# Dirección desde el centro del área hasta el cuerpo
		var dir: Vector3 = (body.global_transform.origin - global_transform.origin).normalized()
		
		# Vector tangente (perpendicular al radio). Puedes cambiar el eje (UP) si quieres otro plano de órbita
		var tangent: Vector3 = dir.cross(Vector3.LEFT).normalized()
		
		# Velocidad inicial para que empiece orbitando
		body.linear_velocity = tangent * randf_range(orbit_speed/2, orbit_speed*2)
		
		# Opcional: quita amortiguación para que no se “paren”
		body.linear_damp = 0.0

func _on_body_exited(body: Node) -> void:
	if body is RigidBody3D:
		bodies.erase(body)
