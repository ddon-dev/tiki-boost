extends AudioStreamPlayer

@export var fade_in_target: float
@export var fade_in_time: float
@export var fade_out_time: int

func fade_in():
	create_tween().tween_property(
		self,
		"volume_linear",
		fade_in_target,
		fade_in_time
	)
	
func fade_out():
	create_tween().tween_property(
		self,
		"volume_db",
		-150,
		fade_out_time
	)
