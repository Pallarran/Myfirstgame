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

# Food consumption: each villager eats FOOD_PER_VILLAGER every FOOD_TICK_INTERVAL
# seconds. If the global food pool can't cover everyone on a given tick, the
# villagers who missed enter the "hungry" state (slower walk, no death — slice
# pillar #1, no fail states that erase progress).
const FOOD_TICK_INTERVAL: float = 12.0
const FOOD_PER_VILLAGER: int = 1

const VILLAGER_SCENE: PackedScene = preload("res://scenes/villagers/villager.tscn")
const WORKER_PANEL_SCENE: PackedScene = preload("res://ui/worker_panel.tscn")

# Starter villager spawn positions cluster near the campfire; the wandering
# AI spreads them out from there.
const STARTER_VILLAGER_POSITIONS: Array = [
	Vector3(1.5, 0.0, 0.8),
	Vector3(-1.2, 0.0, 1.5),
	Vector3(-0.4, 0.0, -1.8),
]

@onready var _plots_root: Node3D = $BuildPlots
@onready var _villagers_root: Node3D = $Villagers
@onready var _hud: CanvasLayer = $HUD
@onready var _build_menu: Control = $HUD/BuildMenu

var _food_tick_accumulator: float = 0.0

func _ready() -> void:
	_build_menu.confirmed.connect(_on_build_confirmed)
	for plot in _plots_root.get_children():
		if plot.has_signal("clicked"):
			plot.clicked.connect(_on_plot_clicked)
	# Heart plot is pre-built per VERTICAL_SLICE_PRD.md and PLOT_LINEAGES.md
	# §1 — the Campfire is already there when the game starts. Auto-build
	# it now without charging the player wood.
	for plot in _plots_root.get_children():
		if plot.lineage != null and plot.lineage.lineage_id == "heart":
			_do_build(plot, false)
	for spawn_position in STARTER_VILLAGER_POSITIONS:
		_spawn_villager(spawn_position)

func _process(delta: float) -> void:
	_food_tick_accumulator += delta
	if _food_tick_accumulator >= FOOD_TICK_INTERVAL:
		_food_tick_accumulator -= FOOD_TICK_INTERVAL
		_do_food_tick()

func _do_food_tick() -> void:
	var hungry_count: int = 0
	for villager in _villagers_root.get_children():
		var ate: bool = GameState.spend_food(FOOD_PER_VILLAGER)
		villager.is_hungry = not ate
		if not ate:
			hungry_count += 1
	GameState.set_hungry_count(hungry_count)

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
	_do_build(plot, true)

# Shared build path. `charge_cost=true` spends wood (regular build via menu);
# `charge_cost=false` is for pre-built / auto-built plots like the Heart.
func _do_build(plot: Node3D, charge_cost: bool) -> void:
	var form: Form = plot.current_form()
	if charge_cost:
		# Safety net: the menu disables Build when broke; this double-checks.
		if not GameState.spend_wood(form.wood_cost):
			return
	# Plot persists post-build (owns building + camouflage), per
	# MAP_SPECIFICATION.md §10.
	var building: Node3D = plot.build_form()
	if building == null:
		return
	if building.has_method("set_plot"):
		building.set_plot(plot)
	# Every built plot gets a floating combined workers+level panel. The
	# panel decides internally whether to render the workers row.
	var panel: Control = WORKER_PANEL_SCENE.instantiate()
	_hud.add_child(panel)
	panel.bind_to(building, plot)
	if building.has_signal("workers_changed"):
		building.workers_changed.connect(func(_c, _m): panel._refresh())
	if form.housing_provided > 0:
		GameState.add_housing(form.housing_provided)
	if form.attracts_villager:
		# plot.global_position now that buildings are plot-local children.
		_spawn_immigrant_near(plot.global_position)
