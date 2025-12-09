extends Area3D

# Ring Settings
@export_category("Settings")
@export_range(20.0, 60.0, 2.0) var boost_speed: float = 40.0
@export var boost_duration: float = 0.6
@export var boost_forward: bool = false
@export var keep_y_velocity: bool = true
@export var one_shot: bool = false

# Audio
@export_category("Audio")
@export var sfx_boost: AudioStreamPlayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body is Marble:
		var marble: Marble = body as Marble
		var vel: Vector3 = marble.linear_velocity
	
		var boost_dir: Vector3
	
		if boost_forward:
			# boosts towards the direction the ring is looking at, hard-traced trajectory
			boost_dir = -global_transform.basis.z
		else:
			# boosts towards the direction of the marble movement
			boost_dir = vel.normalized()
		
		marble.apply_speed_boost(boost_dir, boost_speed, boost_duration, keep_y_velocity)
		sfx_boost.play()

		if one_shot:
			monitoring = false
			if $CollisionShape3D:
				$CollisionShape3D.disabled = true
			$MeshInstance3D.visible = false
			# o queue_free()
