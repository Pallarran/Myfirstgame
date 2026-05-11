# Root controller for the world scene.
#
# Responsibilities:
#   - Esc → return to main menu (releases captured mouse first).
#   - Wire each BuildPlot's `clicked` signal to open the build menu.
#   - On confirmed build: spend wood, swap the plot for the building scene
#     at the plot's transform, then free the plot. For Tents, also bump
#     max housing and spawn an immigrant villager near the new tent.
#   - Spawn 3 starter villagers near the campfire on _ready.
#   - Temporary F1/F2 debug hotkeys for poking the wood resource until
#     buildings can drive it on their own (Woodcutter/Forager land later).
#
# Villagers are anonymous — see memory: villagers-are-anonymous.
extends Node3D

const MAIN_MENU_PATH: String = "res://scenes/main_menu.tscn"
const DEBUG_WOOD_DELTA: int = 5

const VILLAGER_SCENE: PackedScene = preload("res://scenes/villagers/villager.tscn")

# Starter villager spawn positions cluster near the campfire; the wandering
# AI spreads them out from there.
const STARTER_VILLAGER_POSITIONS: Array = [
	Vector3(1.5, 0.0, 0.8),
	Vector3(-1.2, 0.0, 1.5),
	Vector3(-0.4, 0.0, -1.8),
]

@onready var _plots_root: Node3D = $BuildPlots
@onready var _villagers_root: Node3D = $Villagers
@onready var _build_menu: Control = $HUD/BuildMenu
@onready var _building_panel: Control = $HUD/BuildingInfoPanel

func _ready() -> void:
	_build_menu.confirmed.connect(_on_build_confirmed)
	for plot in _plots_root.get_children():
		if plot.has_signal("clicked"):
			plot.clicked.connect(_on_plot_clicked)
	for spawn_position in STARTER_VILLAGER_POSITIONS:
		_spawn_villager(spawn_position)

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

func _spawn_villager(spawn_position: Vector3) -> void:
	var villager: Node3D = VILLAGER_SCENE.instantiate()
	villager.position = spawn_position
	_villagers_root.add_child(villager)

func _spawn_immigrant_near(target_position: Vector3) -> void:
	if not GameState.add_villager():
		return  # at cap (8) — silently skip
	var offset := Vector3(randf_range(-1.8, 1.8), 0.0, randf_range(-1.8, 1.8))
	_spawn_villager(target_position + offset)

func _on_plot_clicked(plot: Node3D) -> void:
	_build_menu.open_for(plot)

func _on_build_confirmed(plot: Node3D) -> void:
	var bt: BuildingType = plot.building_type
	# Safety net: the menu disables Build when broke, but spend_wood double-checks.
	if not GameState.spend_wood(bt.wood_cost):
		return
	var building_scene: PackedScene = load(bt.building_scene_path)
	var building: Node3D = building_scene.instantiate()
	building.transform = plot.transform
	plot.get_parent().add_child(building)
	plot.queue_free()
	# Gathering buildings (Woodcutter, Forager) emit `clicked` for the
	# building info panel. Tents don't have workers and stay non-interactive.
	if building.has_signal("clicked"):
		building.clicked.connect(_on_building_clicked)
	if bt.housing_provided > 0:
		GameState.add_housing(bt.housing_provided)
	if bt.attracts_villager:
		_spawn_immigrant_near(building.position)

func _on_building_clicked(building: Node3D) -> void:
	_building_panel.open_for(building)
