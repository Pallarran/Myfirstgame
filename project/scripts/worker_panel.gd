# Compact floating panel that hovers above a buildable structure, showing
# (when applicable) workers row and (always) level row with an upgrade
# button. No modal — visible at all times once the building exists.
#
# Lives in the world's HUD CanvasLayer. Each plot's `build_form()` spawns
# one and binds it to the new building. Position is recomputed every frame
# from the building's world position with a fixed y-offset above the
# structure, projected to screen space.
#
# The workers row is shown only when the building exposes try_assign /
# max_workers. The level row is shown for every leveable plot (slice 1:
# all of them).
extends Control

const ANCHOR_HEIGHT: float = 4.0

var _building: Node3D = null
var _plot: Node3D = null

@onready var _workers_row: Control = $Panel/VBox/WorkersRow
@onready var _minus: Button = $Panel/VBox/WorkersRow/Minus
@onready var _workers_label: Label = $Panel/VBox/WorkersRow/WorkersLabel
@onready var _plus: Button = $Panel/VBox/WorkersRow/Plus
@onready var _level_row: Control = $Panel/VBox/LevelRow
@onready var _level_label: Label = $Panel/VBox/LevelRow/LevelLabel
@onready var _level_up: Button = $Panel/VBox/LevelRow/LevelUp

func _ready() -> void:
	_minus.pressed.connect(_on_minus_pressed)
	_plus.pressed.connect(_on_plus_pressed)
	_level_up.pressed.connect(_on_level_up_pressed)
	EventBus.workers_changed.connect(_on_workers_changed)
	EventBus.population_changed.connect(_on_population_changed)
	EventBus.wood_changed.connect(_on_wood_changed)

func bind_to(building: Node3D, plot: Node3D) -> void:
	_building = building
	_plot = plot
	# Hide the workers row entirely for buildings that don't have worker slots
	# (Tent, Elder's Tent, Campfire); the level row is always visible.
	var has_workers: bool = building.has_method("try_assign") and "max_workers" in building and building.max_workers > 0
	_workers_row.visible = has_workers
	if plot.has_signal("level_changed"):
		plot.level_changed.connect(_on_plot_level_changed)
	_refresh()

func _process(_delta: float) -> void:
	if not is_instance_valid(_building) or not is_instance_valid(_plot):
		queue_free()
		return
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera == null:
		return
	var world_anchor: Vector3 = _plot.global_position + Vector3(0.0, ANCHOR_HEIGHT, 0.0)
	if camera.is_position_behind(world_anchor):
		visible = false
		return
	visible = true
	var screen_pos: Vector2 = camera.unproject_position(world_anchor)
	position = (screen_pos - size * 0.5).round()

func _refresh() -> void:
	if _building == null or _plot == null:
		return
	if _workers_row.visible:
		_workers_label.text = "%d / %d" % [_building.current_workers, _building.max_workers]
		_plus.disabled = _building.current_workers >= _building.max_workers or GameState.idle_population() <= 0
		_minus.disabled = _building.current_workers <= 0
	_level_label.text = "Lv %d/5" % _plot.current_level
	var next_cost: int = _plot.next_level_up_cost()
	if next_cost < 0:
		_level_up.disabled = true
		_level_up.tooltip_text = "Max level"
	else:
		_level_up.disabled = not GameState.can_afford_wood(next_cost)
		_level_up.tooltip_text = "Upgrade for %d wood" % next_cost

func _on_workers_changed(_assigned: int, _total: int) -> void:
	_refresh()

func _on_population_changed(_current: int, _max: int) -> void:
	_refresh()

func _on_wood_changed(_amount: int) -> void:
	_refresh()  # update level-up affordability

func _on_plot_level_changed(_new_level: int) -> void:
	_refresh()

func _on_plus_pressed() -> void:
	if _building != null:
		_building.try_assign()

func _on_minus_pressed() -> void:
	if _building != null:
		_building.try_unassign()

func _on_level_up_pressed() -> void:
	if _plot != null:
		_plot.try_level_up()
