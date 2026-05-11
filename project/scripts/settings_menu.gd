# In-game settings menu.
#
# Opens via Esc (when no other modal is up). Pauses the tree while open
# so production/villagers/day-night freeze. Buttons:
#   - Resume        — close the menu, unpause.
#   - Main Menu     — back to title screen WITHOUT saving.
#   - Save & Quit   — saves to user://savegame.json then exits the app.
#
# Sliders control AudioManager master / music / sfx volumes.
# Fullscreen toggle flips DisplayServer between windowed and fullscreen.
extends Control

@onready var _master_slider: HSlider = $Panel/Margin/VBox/MasterRow/Slider
@onready var _music_slider: HSlider = $Panel/Margin/VBox/MusicRow/Slider
@onready var _sfx_slider: HSlider = $Panel/Margin/VBox/SFXRow/Slider
@onready var _fullscreen_toggle: CheckButton = $Panel/Margin/VBox/FullscreenRow/Toggle
@onready var _resume_button: Button = $Panel/Margin/VBox/Buttons/Resume
@onready var _main_menu_button: Button = $Panel/Margin/VBox/Buttons/MainMenu
@onready var _save_quit_button: Button = $Panel/Margin/VBox/Buttons/SaveQuit

func _ready() -> void:
	# Keep this UI responsive while the rest of the tree is paused.
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	_master_slider.value = AudioManager._master_volume
	_music_slider.value = AudioManager._music_volume
	_sfx_slider.value = AudioManager._sfx_volume
	_fullscreen_toggle.button_pressed = (
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		or DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	)
	_master_slider.value_changed.connect(_on_master_changed)
	_music_slider.value_changed.connect(_on_music_changed)
	_sfx_slider.value_changed.connect(_on_sfx_changed)
	_fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	_resume_button.pressed.connect(close)
	_main_menu_button.pressed.connect(_on_main_menu_pressed)
	_save_quit_button.pressed.connect(_on_save_quit_pressed)

func open() -> void:
	visible = true
	get_tree().paused = true

func close() -> void:
	visible = false
	get_tree().paused = false

func is_open() -> bool:
	return visible

func _on_master_changed(v: float) -> void:
	AudioManager.set_master_volume(v)

func _on_music_changed(v: float) -> void:
	AudioManager.set_music_volume(v)

func _on_sfx_changed(v: float) -> void:
	AudioManager.set_sfx_volume(v)

func _on_fullscreen_toggled(value: bool) -> void:
	if value:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_main_menu_pressed() -> void:
	# Discard the in-progress run; head back to the title screen. Player
	# can still press Continue later if they had previously saved.
	close()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_save_quit_pressed() -> void:
	var world: Node = get_tree().current_scene
	if world != null and world.has_method("serialize_world"):
		SaveSystem.save_world(world)
	get_tree().quit()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		close()
