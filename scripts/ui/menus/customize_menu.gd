extends VBoxContainer

# Audio
@export var sfx_pressed: AudioStreamPlayer

# Menus
@onready var init_menu: VBoxContainer = %InitMenu
@onready var customize_menu: VBoxContainer = %CustomizeMenu
@onready var skins_container: GridContainer = %SkinsContainer
@onready var trail_color_picker: VBoxContainer = %TrailColorPicker
@onready var skins_menu: VBoxContainer = %SkinsMenu
@export var menu_slide: AnimationPlayer

# Buttons
@onready var return_menu: Button = %CustomizeReturn
@onready var trail_settings: Button = %TrailSettings
@onready var trail_toggle: CheckButton = %TrailToggle


func _ready() -> void:
	return_menu.pressed.connect(go_back)
	trail_settings.pressed.connect(trail_settings_menu)
	trail_toggle.pressed.connect(trail_toggle_pressed)
	for skin in PlayerMaterials.skins:
		var button = TextureButton.new()
		button.ignore_texture_size = true
		button.stretch_mode = 0
		button.custom_minimum_size = Vector2(80, 80)
		button.set_texture_normal(skin.icon)
		button.set_texture_hover(skin.highlight_icon)
		skins_container.add_child(button)
		button.pressed.connect(func():
			sfx_pressed.play()
			GameManager.player_customization.current_skin = skin.material
			PlayerMaterials.skin_changed.emit()
			GameManager.save_current_customization()
		)
	
func go_back():
	sfx_pressed.play()
	init_menu.visible = true
	menu_slide.play("slide_right")
	MenuManager.customize_focus = !MenuManager.customize_focus
	MenuManager.customize_exit.emit()
	await menu_slide.animation_finished
	customize_menu.visible = false

func trail_toggle_pressed():
	sfx_pressed.play()

func trail_settings_menu():
	trail_color_picker.visible = true
	skins_menu.visible = false
	return_menu.visible = false
	sfx_pressed.play()
