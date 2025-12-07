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

#region Player Customization Vars
const PLAYER_CUSTOMIZATION_PATH = "user://player_customization.tres"
var player_customization: PlayerCustomization
var def_skin = preload("uid://b6myh8ll5udm3")
var def_state: bool = true
var def_color: Color = Color("0068d2")
#endregion

func _ready():
#region Game Settings
	if ResourceLoader.exists(GAME_SETTINGS_PATH):
		game_settings = load(GAME_SETTINGS_PATH)
		apply_settings(game_settings)
	else:
		game_settings = GameSettings.new()
		ResourceSaver.save(game_settings, GAME_SETTINGS_PATH)
		load_default_settings()
#endregion
	
#region Player Customization
	if ResourceLoader.exists(PLAYER_CUSTOMIZATION_PATH):
		player_customization = load(PLAYER_CUSTOMIZATION_PATH)
		apply_trail_settings(player_customization.trail_enabled,
		player_customization.trail_color)
		apply_saved_skin(player_customization.current_skin)
	else:
		player_customization = PlayerCustomization.new()
		player_customization.current_skin = def_skin
		player_customization.trail_enabled = def_state
		player_customization.trail_color = def_color
		save_current_customization()
#endregion

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
	
func apply_settings(new_game_settings: GameSettings):
	AudioServer.set_bus_volume_linear(AUDIOBUS.master, new_game_settings.master_volume)
	AudioServer.set_bus_volume_linear(AUDIOBUS.music, new_game_settings.music_volume)
	AudioServer.set_bus_volume_linear(AUDIOBUS.sfx, new_game_settings.sfx_volume)
	GameManager.game_settings.screen_mode = get_window().mode
	GameManager.game_settings.resolution = get_window().size
#endregion

#region Player Customization Functions
func apply_saved_skin(new_custom_skin: StandardMaterial3D):
	player_customization.current_skin = new_custom_skin

func apply_trail_settings(current_state: bool, color: Color):
	player_customization.trail_enabled = current_state
	player_customization.trail_color = color

func save_current_customization():
	ResourceSaver.save(player_customization, PLAYER_CUSTOMIZATION_PATH)
	
func set_default_trail_color():
	player_customization.trail_color = def_color
#endregion

#region Level Music
func play_music():
	if StageHandler.current_level.is_tutorial:
			MusicManager.play_tutorial_music()
	if StageHandler.current_level.is_main_menu:
			MusicManager.play_menu_music()
#endregion
