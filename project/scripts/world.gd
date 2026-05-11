# Root controller for the world scene.
#
# Minimal during Milestone A — only handles returning to the main menu on Esc
# so the developer can navigate back without alt-tabbing. As later milestones
# add buildings, day/night, save/load, etc., the wiring grows from here.
extends Node3D

const MAIN_MENU_PATH: String = "res://scenes/main_menu.tscn"

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		# Release the mouse in case the camera rig had it captured during orbit.
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		get_tree().change_scene_to_file(MAIN_MENU_PATH)
