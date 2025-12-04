extends RigidBody3D

@onready var path_follow_3d: PathFollow3D = %MarblePath
@export var marble_speed: float

func _physics_process(delta: float) -> void:
	path_follow_3d.progress += marble_speed  * delta
	rotate_x(-0.030)
