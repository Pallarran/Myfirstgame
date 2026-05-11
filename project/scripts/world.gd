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

# Autosave every 10 minutes per VERTICAL_SLICE_PRD.md §2.
const AUTOSAVE_INTERVAL: float = 600.0

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
@onready var _settings_menu: Control = $HUD/SettingsMenu

var _food_tick_accumulator: float = 0.0
var _autosave_accumulator: float = 0.0

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
	# Apply pending save data on top of the fresh setup, if any (loaded
	# from the main menu's Continue button).
	var pending: Dictionary = SaveSystem.consume_pending_load()
	if not pending.is_empty():
		_apply_pending_load(pending)
	# Start ambient music. Silent if no file is dropped yet.
	AudioManager.play_music(AudioManager.MUSIC_PATH_AMBIENT_CAMP)

func _process(delta: float) -> void:
	_food_tick_accumulator += delta
	if _food_tick_accumulator >= FOOD_TICK_INTERVAL:
		_food_tick_accumulator -= FOOD_TICK_INTERVAL
		_do_food_tick()
	_autosave_accumulator += delta
	if _autosave_accumulator >= AUTOSAVE_INTERVAL:
		_autosave_accumulator = 0.0
		SaveSystem.save_world(self)

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
			# Esc now opens the in-game settings menu instead of going
			# straight to the main menu. From settings the player can pick
			# Resume / Main Menu / Save & Quit. Other modals (BuildMenu,
			# TutorialPrompts) consume Esc before us when they're visible.
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			_settings_menu.open()
		KEY_F1:
			GameState.add_wood(DEBUG_WOOD_DELTA)
		KEY_F2:
			GameState.spend_wood(DEBUG_WOOD_DELTA)
		KEY_F6:
			# Manual save (debug). Once the settings menu lands (E-6),
			# this becomes a "Save & Quit" menu action.
			SaveSystem.save_world(self)
		KEY_F7:
			# Manual reload: write nothing, just bounce through the main
			# menu so Continue picks up the save.
			get_tree().change_scene_to_file(MAIN_MENU_PATH)

func _spawn_villager(spawn_position: Vector3) -> void:
	var villager: Node3D = VILLAGER_SCENE.instantiate()
	villager.position = spawn_position
	_villagers_root.add_child(villager)

func _spawn_immigrant_near(target_position: Vector3) -> void:
	if not GameState.add_villager():
		return  # at cap (8) — silently skip
	var offset := Vector3(randf_range(-1.8, 1.8), 0.0, randf_range(-1.8, 1.8))
	_spawn_villager(target_position + offset)
	EventBus.villager_arrived.emit()

func _on_plot_clicked(plot: Node3D) -> void:
	_build_menu.open_for(plot)

# --- Save / load --------------------------------------------------------
# SaveSystem calls serialize_world on save; the result merges into the
# top-level save dict. On load, world.gd._ready calls _apply_pending_load
# after its normal setup runs (Heart auto-built, starter villagers spawned).

func serialize_world() -> Dictionary:
	var plots: Array = []
	for plot in _plots_root.get_children():
		if plot.activation_state != "Built":
			continue
		var workers: int = 0
		var b: Node3D = plot.current_building_instance
		if b != null and "current_workers" in b:
			workers = b.current_workers
		plots.append({
			"name": plot.name,
			"form_index": plot.current_form_index,
			"level": plot.current_level,
			"workers": workers,
		})
	return {"plots": plots}

func _apply_pending_load(data: Dictionary) -> void:
	# 1. Restore GameState fields (resources, time, day, pop counts).
	SaveSystem.apply_game_state(data.get("game_state", {}))
	# 2. Restore plot states. The Heart was auto-built at level 1; if the
	#    save has it at a higher level, bring it up. For other plots, build
	#    them silently and set their level + workers.
	var world_data: Dictionary = data.get("world", {})
	var saved_plots: Array = world_data.get("plots", [])
	for saved in saved_plots:
		var plot_name: String = saved.get("name", "")
		if not _plots_root.has_node(plot_name):
			continue
		var plot: Node3D = _plots_root.get_node(plot_name)
		# Build the plot if it's not already (Heart is; others aren't).
		if plot.activation_state != "Built":
			_do_build(plot, false)
		# Set level (visual + multiplier driven through set_level signal).
		var saved_level: int = int(saved.get("level", 1))
		plot.current_level = saved_level
		if plot.current_building_instance != null and plot.current_building_instance.has_method("set_level"):
			plot.current_building_instance.set_level(saved_level)
		# Restore worker count by setting the building's current_workers
		# directly. GameState.workers_assigned was restored above, so we
		# don't go through try_assign (which would double-bump the global tally).
		var b: Node3D = plot.current_building_instance
		if b != null and "current_workers" in b:
			var saved_workers: int = int(saved.get("workers", 0))
			b.current_workers = saved_workers
			if b.has_signal("workers_changed"):
				b.workers_changed.emit(saved_workers, b.max_workers)
	# 3. Reconcile villager count: spawn extras up to current_population.
	while _villagers_root.get_child_count() < GameState.current_population:
		var offset: Vector3 = Vector3(randf_range(-3.0, 3.0), 0.0, randf_range(-3.0, 3.0))
		_spawn_villager(offset)

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
	# Notify the feed (Heart auto-build also fires this; for slice 1 a "Camp
	# established" line at game start is friendly rather than noisy).
	EventBus.building_constructed.emit(form.display_name)
	# Audio feedback — silent if the file doesn't exist yet.
	if charge_cost:  # don't ding on the Heart's auto-build at game start
		AudioManager.play_sfx("build_complete")
