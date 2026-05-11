# Main menu controller.
#
# Hooks up the three menu buttons. "Continue" stays disabled until a save
# system lands (Milestone E); for now there's nothing to load.
extends Control

const WORLD_SCENE_PATH: String = "res://scenes/world.tscn"

@onready var _new_game_button: Button = $CenterContainer/Buttons/NewGameButton
@onready var _continue_button: Button = $CenterContainer/Buttons/ContinueButton
@onready var _quit_button: Button = $CenterContainer/Buttons/QuitButton

func _ready() -> void:
	_new_game_button.pressed.connect(_on_new_game_pressed)
	_quit_button.pressed.connect(_on_quit_pressed)
	_continue_button.disabled = true

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file(WORLD_SCENE_PATH)

func _on_quit_pressed() -> void:
	get_tree().quit()
