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

const VILLAGER_SCENE: PackedScene = preload("res://scenes/villagers/villager.tscn")

# Starter villagers (per VERTICAL_SLICE_PRD.md: 3 pre-named villagers at game
# start). Positions cluster around the campfire; the wandering AI will spread
# them out from there on its own.
const STARTER_VILLAGERS: Array = [
	{"name": "Bram", "position": Vector3(1.5, 0.0, 0.8)},
	{"name": "Edda", "position": Vector3(-1.2, 0.0, 1.5)},
	{"name": "Cuth", "position": Vector3(-0.4, 0.0, -1.8)},
]

# Names new immigrants get assigned when a Tent finishes. Drawn from this
# pool in a shuffled order so names don't repeat in a session. Pool is
# sized to comfortably exceed the slice's POPULATION_HARD_CAP - starters.
const IMMIGRANT_NAMES: Array = [
	"Wynn", "Hild", "Osric", "Aelfric", "Bernic", "Cynric", "Drogo", "Eadwig",
]

# Traits are cosmetic in this slice — they appear on the info card but
# don't yet affect mechanics. Hooks for trait-driven behavior (faster
# work, hunger resistance, etc.) come in later milestones.
const TRAITS: Array = [
	"Hardy", "Quick", "Patient", "Cheerful", "Skilled", "Stout", "Keen",
]

const AGE_RANGE: Vector2i = Vector2i(16, 55)

@onready var _plots_root: Node3D = $BuildPlots
@onready var _villagers_root: Node3D = $Villagers
@onready var _build_menu: Control = $HUD/BuildMenu
@onready var _info_card: Control = $HUD/VillagerInfoCard

var _immigrant_pool: Array = []

func _ready() -> void:
	_build_menu.confirmed.connect(_on_build_confirmed)
	for plot in _plots_root.get_children():
		if plot.has_signal("clicked"):
			plot.clicked.connect(_on_plot_clicked)
	for data in STARTER_VILLAGERS:
		_spawn_villager(data["name"], data["position"])
	_immigrant_pool = IMMIGRANT_NAMES.duplicate()
	_immigrant_pool.shuffle()

func _spawn_villager(villager_name: String, spawn_position: Vector3) -> void:
	var villager: Node3D = VILLAGER_SCENE.instantiate()
	villager.position = spawn_position
	villager.villager_name = villager_name
	villager.villager_age = randi_range(AGE_RANGE.x, AGE_RANGE.y)
	villager.villager_trait = TRAITS.pick_random()
	villager.villager_job = "Idle"
	villager.clicked.connect(_on_villager_clicked)
	_villagers_root.add_child(villager)

func _on_villager_clicked(villager: Node3D) -> void:
	_info_card.open_for(villager)

func _spawn_immigrant_near(target_position: Vector3) -> void:
	if not GameState.add_villager():
		return  # at cap (8) — silently skip
	var offset := Vector3(randf_range(-1.8, 1.8), 0.0, randf_range(-1.8, 1.8))
	_spawn_villager(_next_immigrant_name(), target_position + offset)

func _next_immigrant_name() -> String:
	if _immigrant_pool.is_empty():
		return "Stranger"
	return _immigrant_pool.pop_back()

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
	# Tent-specific: bump housing and attract an immigrant. When Woodcutter/
	# Forager arrive in Milestone D, this branch will move into a building-
	# type catalog. Hardcoded on BUILDING_NAME for now since Tent is the only
	# buildable type.
	if plot.BUILDING_NAME == "Tent":
		GameState.add_housing(GameState.TENT_HOUSING)
		_spawn_immigrant_near(building.position)
