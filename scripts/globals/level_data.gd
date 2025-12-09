class_name LevelData
extends Resource

@export_file("*.tscn") var level_path: String
@export var is_main_menu: bool
@export var is_level_pack_1: bool
@export var is_level_pack_2: bool
@export var is_tutorial: bool


@export_category("Highscore and Medals")
#All the records are saved in seconds
@export var gold_medal_time: int
@export var silver_medal_time: int
@export var bronze_medal_time: int
