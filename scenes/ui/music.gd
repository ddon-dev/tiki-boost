extends AudioStreamPlayer

func short_fade_in():
	var fade_in = get_tree().create_tween()
	fade_in.tween_property(
		self,
		"volume_db",
		-12,
		0.5
	)
	
func fade_out():
	var fade_out = get_tree().create_tween()
	fade_out.tween_property(
		self,
		"volume_db",
		-150,
		7
	)
