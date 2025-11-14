extends AudioStreamPlayer

@export var fade_in_target: int
@export var fade_in_time: float
@export var fade_out_time: int

func fade_in():
	var fade_in = get_tree().create_tween()
	fade_in.tween_property(
		self,
		"volume_db",
		fade_in_target,
		fade_in_time
	)
	
func fade_out():
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(
		self,
		"volume_db",
		-150,
		fade_out_time
	)
