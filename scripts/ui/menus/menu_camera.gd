extends Camera3D

@onready var stage_center: Marker3D = %StageCenter
@onready var path_follow_3d: PathFollow3D = $".."
@export var camera_speed: int = 25

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	look_at(stage_center.global_position, Vector3.UP)
	path_follow_3d.progress += camera_speed  * delta
	
