class_name RotatingObject extends Node3D

@export var direction: Direction = Direction.X_Axis
## Determines the rotation speed. Negative values makes the object rotate backwards.
@export_range(-2.0, 2.0, 0.1) var rotating_speed: float = 1.0

enum Direction {
	## Pitch
	X_Axis,
	## Yaw
	Y_Axis,
	## Roll
	Z_Axis
}

func _physics_process(delta: float) -> void:
	rotation += rotating_speed * get_direction_vector() * delta

func get_direction_vector() -> Vector3:
	match direction:
		Direction.X_Axis: return Vector3(1, 0, 0)
		Direction.Y_Axis: return Vector3(0, 1, 0)
		Direction.Z_Axis: return Vector3(0, 0, 1)
		_: return Vector3.ZERO
