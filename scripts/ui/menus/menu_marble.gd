extends RigidBody3D

@onready var path_follow_3d: PathFollow3D = %MarblePath
@export var marble_speed: float
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _ready() -> void:
	mesh.material_override = GameManager.player_customization.current_skin
	PlayerMaterials.skin_changed.connect(skin_selected)

func _physics_process(delta: float) -> void:
	path_follow_3d.progress += marble_speed  * delta
	rotate_x(-0.030)

func skin_selected():
	mesh.material_override = GameManager.player_customization.current_skin
