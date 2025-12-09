extends Node

const SAVE_FILE_PATH = "user://save_file.tres"
var save_data: SaveData

func _ready() -> void:
	load_save_file()
	
func load_save_file():
	if ResourceLoader.exists(SAVE_FILE_PATH):
		save_data = load(SAVE_FILE_PATH)
	else:
		save_data = SaveData.new()

func save_save_file():
	ResourceSaver.save(save_data, SAVE_FILE_PATH)
	
func get_player_record(level_path: String) -> PlayerRecord:
	if !save_data.player_records.has(level_path):
		var new_record = PlayerRecord.new()
		save_data.player_records[level_path] = new_record
		return new_record
		
	return save_data.player_records[level_path]
	
func update_highscore(level_path: String, new_highscore: float):
	var record = get_player_record(level_path)
	if record.highscore == 0 or new_highscore < record.highscore:
		record.highscore = new_highscore
		set_medal(record, level_path, new_highscore)
		save_save_file()
		
func set_medal(record: PlayerRecord, level_path: String, time: float):
	var level_data: LevelData = StageHandler.current_level
	var medal = 0
	if time <= level_data.gold_medal_time:
		medal = 3
	elif time <= level_data.silver_medal_time:
		medal = 2
	elif time <= level_data.bronze_medal_time:
		medal = 1
	
	# Updates medal to the best one possible
	if medal > record.medal_achieved:
		record.medal_achieved = medal
