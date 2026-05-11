# Main menu controller.
#
# Three buttons: New Game (always enabled), Continue (enabled when a save
# file exists; loads it and switches to the world), Quit.
extends Control

const WORLD_SCENE_PATH: String = "res://scenes/world.tscn"

@onready var _new_game_button: Button = $CenterContainer/Buttons/NewGameButton
@onready var _continue_button: Button = $CenterContainer/Buttons/ContinueButton
@onready var _quit_button: Button = $CenterContainer/Buttons/QuitButton

func _ready() -> void:
	_new_game_button.pressed.connect(_on_new_game_pressed)
	_continue_button.pressed.connect(_on_continue_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)
	_continue_button.disabled = not SaveSystem.save_exists()

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file(WORLD_SCENE_PATH)

func _on_continue_pressed() -> void:
	if not SaveSystem.load_file():
		# Couldn't read the save — just fall through to a new game.
		get_tree().change_scene_to_file(WORLD_SCENE_PATH)
		return
	# SaveSystem holds the parsed data; world.gd._ready will consume it
	# after its normal setup and apply state on top.
	get_tree().change_scene_to_file(WORLD_SCENE_PATH)

func _on_quit_pressed() -> void:
	get_tree().quit()
