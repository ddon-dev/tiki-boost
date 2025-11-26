extends Area3D

@export var boost_speed: float = 40.0
@export var boost_duration: float = 0.6
@export var one_shot: bool = false

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Marble:
		var marble := body as Marble

		var vel: Vector3 = marble.linear_velocity

		# Si la bola está casi quieta, evitamos un vector casi cero
		if vel.length() < 0.1:
			# fallback opcional: usar orientación del anillo o no hacer nada
			# var fallback_dir = -global_transform.basis.z
			# marble.apply_speed_boost(fallback_dir, boost_speed, boost_duration)
			return

		var boost_dir: Vector3 = vel.normalized()

		marble.apply_speed_boost(boost_dir, boost_speed, boost_duration)

		if one_shot:
			monitoring = false
			if $CollisionShape3D:
				$CollisionShape3D.disabled = true
			$MeshInstance3D.visible = false
			# o queue_free()
