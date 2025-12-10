extends Camera3D

@onready var stage_center: Marker3D = %StageCenter
@onready var default_position: Marker3D = %DefaultPosition
@onready var customize_area: Node3D = %CustomizeArea
@onready var customize_position: Marker3D = %CustomizePosition
@onready var customize_center: Marker3D = %CustomizeCenter
@onready var path_follow_3d: PathFollow3D = $".."
@export var default_fov = 75
@export var customize_fov = 55
@export var camera_speed: int = 25

func _ready() -> void:
	MenuManager.customize_exit.connect(return_default_position)

func _physics_process(delta: float) -> void:
	if MenuManager.customize_focus:
		customize_area.visible = true
		look_at(customize_center.global_position, Vector3.UP)
		global_position = customize_position.global_position
		fov = customize_fov
		pass
	else:
		look_at(stage_center.global_position, Vector3.UP)
		path_follow_3d.progress += camera_speed  * delta
		
func return_default_position():
	fov = default_fov
	customize_area.visible = false
	path_follow_3d.progress = 0.0
	path_follow_3d.progress_ratio = 0.0
	global_position = default_position.global_position
