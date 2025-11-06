extends Control

@onready var level_manager: LevelManager = %LevelManager
@onready var restart_button: Button = %RestartButton
@onready var continue_button: Button = %ContinueButton
@onready var menu_button: Button = %MenuButton

func _ready() -> void:
	level_manager.level_finished.connect(_on_level_finished)
	
	restart_button.pressed.connect(_on_restart_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)
	menu_button.pressed.connect(_on_menu_button_pressed)

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_continue_button_pressed() -> void:
	pass

func _on_menu_button_pressed() -> void:
	pass

func _on_level_finished() -> void:
	visible = true
	create_tween().tween_property(self, "modulate:a", 1.0, 0.75)
