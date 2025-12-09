class_name PlayerRecord
extends Resource


enum medals{
	none = 0,
	bronze = 1,
	silver = 2,
	gold = 3
}
@export_range(0,3) var medal_achieved: int = medals.none
@export var highscore: float = 0.0 #Highscore in seconds
