extends Node

@export var levels: Array[LevelData]
@export var main_menu: LevelData
var current_level: LevelData
@export var last_level: LevelData # Set to the first tutorial level by default
signal level_changed(new_level_path)

func go_to_init_level():
	go_to_level(levels[0])
	get_tree().change_scene_to_file(current_level.level_path)

func go_to_next_level():
	var level_idx = levels.find(current_level)
	if level_idx == -1:
		go_to_menu()
	
	if level_idx + 1 < levels.size():
		var next_level_path = levels.get(level_idx + 1)
		go_to_level(next_level_path)
	else:
		go_to_menu()

func go_to_level(level: LevelData):
	current_level = level
	set_last_level()
	get_tree().change_scene_to_file(current_level.level_path)
	level_changed.emit(current_level)

func set_last_level():
	last_level = current_level

func go_to_menu():
	current_level = main_menu
	get_tree().change_scene_to_file(current_level.level_path)

func restart_level():
	get_tree().reload_current_scene()

func get_level_data(path: String) -> LevelData:
	var level_data_path = ResourceLoader.load(path)
	if level_data_path is LevelData:
		return level_data_path
	else:
		return null
