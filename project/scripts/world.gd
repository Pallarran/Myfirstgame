# Root controller for the world scene.
#
# Handles top-level world input — currently just Esc-to-menu and some
# temporary debug keys for poking the wood resource until real buildings
# land in Milestone B. Debug keys should be removed once Tents/Woodcutters
# exist and can drive wood up and down on their own.
extends Node3D

const MAIN_MENU_PATH: String = "res://scenes/main_menu.tscn"
const DEBUG_WOOD_DELTA: int = 5  # amount added/removed per F1/F2 press

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_ESCAPE:
			# Release the mouse in case the camera rig had it captured during orbit.
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
		KEY_F1:
			# TEMP: add wood to verify the GameState → EventBus → TopBar chain.
			GameState.add_wood(DEBUG_WOOD_DELTA)
		KEY_F2:
			# TEMP: spend wood (no-op if insufficient — returns false).
			GameState.spend_wood(DEBUG_WOOD_DELTA)
