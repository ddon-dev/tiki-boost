extends RayCast3D

@onready var marble: Marble = %Marble

func _physics_process(_delta: float) -> void:
	global_position = marble.get_node("MeshInstance3D").global_position
	
	if is_colliding():
		marble.grounded = true
	else:
		marble.grounded = false
