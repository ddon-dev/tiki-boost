extends Node

# Bools
var canPause: bool = true

#region Game Settings Vars
const GAME_SETTINGS_PATH = "user://game_settings.tres"
var game_settings: GameSettings
const MODES = {
"Fullscreen": Window.MODE_FULLSCREEN,
"Windowed": Window.MODE_WINDOWED,
}
var current_screen = DisplayServer.window_get_current_screen()
var def_res = DisplayServer.screen_get_size(current_screen)
enum AUDIOBUS {
	master = 0,
	music = 1,
	sfx = 2,
}
var def_vol: float = 0.75
#endregion

func _ready():
	if ResourceLoader.exists(GAME_SETTINGS_PATH):
		game_settings = load(GAME_SETTINGS_PATH)
		apply_settings(game_settings)
	else:
		game_settings = GameSettings.new()
		ResourceSaver.save(game_settings, GAME_SETTINGS_PATH)
		load_default_settings()

#region Game Settings Functions
func load_default_settings():
	get_window().size = def_res
	get_window().move_to_center()
	AudioServer.set_bus_volume_linear(AUDIOBUS.master, def_vol)
	AudioServer.set_bus_volume_linear(AUDIOBUS.music, def_vol)
	AudioServer.set_bus_volume_linear(AUDIOBUS.sfx, def_vol)
	get_window().mode = Window.MODE_FULLSCREEN

func save_settings():
	ResourceSaver.save(game_settings, GAME_SETTINGS_PATH)

func load_settings():
	ResourceLoader.load(GAME_SETTINGS_PATH)
	game_settings = load(GAME_SETTINGS_PATH)
	apply_settings(game_settings)
	
func apply_settings(game_settings: GameSettings):
	AudioServer.set_bus_volume_linear(AUDIOBUS.master, game_settings.master_volume)
	AudioServer.set_bus_volume_linear(AUDIOBUS.music, game_settings.music_volume)
	AudioServer.set_bus_volume_linear(AUDIOBUS.sfx, game_settings.sfx_volume)
	GameManager.game_settings.screen_mode = get_window().mode
	GameManager.game_settings.resolution = get_window().size
#endregion
