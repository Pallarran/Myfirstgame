# Root controller for the world scene.
#
# Responsibilities:
#   - Esc → return to main menu (releases captured mouse first).
#   - Wire each BuildPlot's `clicked` signal to open the build menu.
#   - On confirmed build: spend wood, swap the plot for the building scene
#     at the plot's transform, then free the plot.
#   - Temporary F1/F2 debug hotkeys for poking the wood resource until
#     buildings can drive it on their own (Woodcutter/Forager land later).
extends Node3D

const MAIN_MENU_PATH: String = "res://scenes/main_menu.tscn"
const DEBUG_WOOD_DELTA: int = 5

@onready var _plots_root: Node3D = $BuildPlots
@onready var _build_menu: Control = $HUD/BuildMenu

func _ready() -> void:
	_build_menu.confirmed.connect(_on_build_confirmed)
	for plot in _plots_root.get_children():
		if plot.has_signal("clicked"):
			plot.clicked.connect(_on_plot_clicked)

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed and not event.echo):
		return
	match event.keycode:
		KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().change_scene_to_file(MAIN_MENU_PATH)
		KEY_F1:
			GameState.add_wood(DEBUG_WOOD_DELTA)
		KEY_F2:
			GameState.spend_wood(DEBUG_WOOD_DELTA)

func _on_plot_clicked(plot: Node3D) -> void:
	_build_menu.open_for(plot)

func _on_build_confirmed(plot: Node3D) -> void:
	# Safety net: the menu disables Build when broke, but spend_wood double-checks.
	if not GameState.spend_wood(plot.BUILDING_COST):
		return
	var building_scene: PackedScene = load(plot.BUILDING_SCENE_PATH)
	var building: Node3D = building_scene.instantiate()
	building.transform = plot.transform
	plot.get_parent().add_child(building)
	plot.queue_free()
