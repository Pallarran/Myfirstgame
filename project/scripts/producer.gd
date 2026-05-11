# Shared script for gathering buildings (Woodcutter, Forager, Water Carrier).
#
# Drives auto-production on a fixed cadence. When staffed, every
# `production_interval` seconds the building adds:
#   production_amount × level_multiplier × current_workers
# of its `resource_type` to GameState. Fractional output is held in a small
# accumulator and emitted as whole units, so a 1.25× multiplier produces
# 1 wood per tick four times then 2 wood on the fifth tick.
#
# Click-to-boost: clicking the structure adds BOOST_AMOUNT × level_multiplier
# of the resource instantly with a floating "+N" text. No cooldown. Requires
# at least one worker; unstaffed buildings ignore boost clicks.
#
# Worker assignment is count-based (no per-villager identity), managed via
# the floating worker panel that calls try_assign / try_unassign.
#
# `_plot` is set by world.gd via `set_plot()` right after instantiation so
# we can read the plot's current_level for output scaling.
extends Node3D

signal clicked(building: Node3D)
signal workers_changed(current: int, max: int)

const FLOATING_TEXT_SCENE: PackedScene = preload("res://ui/floating_text_3d.tscn")

const BOOST_AMOUNT: int = 2

@export_enum("wood", "food", "water") var resource_type: String = "wood"
@export var production_amount: int = 1
@export var production_interval: float = 8.0
@export var max_workers: int = 1

var current_workers: int = 0

var _plot: Node3D = null
var _tick_accumulator: float = 0.0
var _output_accumulator: float = 0.0  # fractional output, emitted as ints

@onready var _area: Area3D = $ClickArea

func _ready() -> void:
	_area.input_event.connect(_on_area_input)

func set_plot(plot: Node3D) -> void:
	_plot = plot

func _process(delta: float) -> void:
	if current_workers <= 0:
		return
	_tick_accumulator += delta
	if _tick_accumulator >= production_interval:
		_tick_accumulator -= production_interval
		var level_mult: float = 1.0
		if _plot != null and _plot.has_method("current_level_multiplier"):
			level_mult = _plot.current_level_multiplier()
		_output_accumulator += production_amount * level_mult * float(current_workers)
		var whole: int = int(_output_accumulator)
		if whole > 0:
			_output_accumulator -= whole
			_grant_resource(whole)

# --- Worker assignment (called by the floating worker panel) -------------

func try_assign() -> bool:
	if current_workers >= max_workers:
		return false
	if not GameState.assign_worker():
		return false
	current_workers += 1
	workers_changed.emit(current_workers, max_workers)
	return true

func try_unassign() -> bool:
	if current_workers <= 0:
		return false
	if not GameState.unassign_worker():
		return false  # shouldn't happen if state is consistent
	current_workers -= 1
	workers_changed.emit(current_workers, max_workers)
	return true

# --- Click handling ------------------------------------------------------

func _on_area_input(_camera: Node, event: InputEvent, _pos: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)
		_try_boost()

func _try_boost() -> void:
	if current_workers <= 0:
		return
	var level_mult: float = 1.0
	if _plot != null and _plot.has_method("current_level_multiplier"):
		level_mult = _plot.current_level_multiplier()
	var amount: int = int(round(BOOST_AMOUNT * level_mult))
	if amount <= 0:
		return
	_grant_resource(amount)
	_spawn_boost_text(amount)

func _grant_resource(amount: int) -> void:
	match resource_type:
		"wood":
			GameState.add_wood(amount)
		"food":
			GameState.add_food(amount)
		"water":
			GameState.add_water(amount)

func _spawn_boost_text(amount: int) -> void:
	var text: Label3D = FLOATING_TEXT_SCENE.instantiate()
	text.text = "+%d %s" % [amount, resource_type]
	add_child(text)
