extends Node3D

@onready var death_zone: DeathZone = $Environment/Objects/DeathZone
@onready var cone_death_area: Area3D = $Environment/Terrain/BorderCone/ConeDeathArea
@onready var deadly_gates_area: Area3D = $Environment/Terrain/DeadlyGates/DeadlyGatesArea

func _ready() -> void:
	cone_death_area.body_entered.connect(_body_entered)
	deadly_gates_area.body_entered.connect(_body_entered)

func _body_entered(body: Node3D) -> void:
	if body is Marble:
		death_zone.deadly_object_touched.emit()
