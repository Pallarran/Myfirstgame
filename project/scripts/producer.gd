# Shared script for gathering buildings (Woodcutter, Forager).
#
# Drives auto-production on a fixed cadence: every `production_interval`
# seconds, adds (`production_amount` × `current_workers`) of `resource_type`
# to GameState. Production pauses when current_workers == 0.
#
# Worker assignment is count-based (no per-villager identity) and is
# managed by the building_info_panel via try_assign / try_unassign.
# Buildings emit `clicked(self)` on left-click so world.gd can open the
# panel.
#
# Each scene sets resource_type / production_amount / production_interval /
# max_workers on the root node.
extends Node3D

signal clicked(building: Node3D)
signal workers_changed(current: int, max: int)

const FLOATING_TEXT_SCENE: PackedScene = preload("res://ui/floating_text_3d.tscn")

# Click-to-boost: clicking a staffed gathering building gives a small
# instant burst. Cooldown keeps it a "nudge" rather than a spammable
# bypass of the auto-tick rate.
const BOOST_AMOUNT: int = 2
const BOOST_COOLDOWN: float = 2.0

@export_enum("wood", "food") var resource_type: String = "wood"
@export var production_amount: int = 1
@export var production_interval: float = 8.0
@export var max_workers: int = 1

var current_workers: int = 0
var _accumulator: float = 0.0
var _last_boost_time: float = -1000.0

@onready var _area: Area3D = $ClickArea

func _ready() -> void:
	_area.input_event.connect(_on_area_input)

func _process(delta: float) -> void:
	if current_workers <= 0:
		return
	_accumulator += delta
	if _accumulator >= production_interval:
		_accumulator -= production_interval
		var produced: int = production_amount * current_workers
		match resource_type:
			"wood":
				GameState.add_wood(produced)
			"food":
				GameState.add_food(produced)

# --- Worker assignment (called by building_info_panel) -------------------

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
		return  # unstaffed buildings can't be boosted — nothing to encourage
	var now: float = Time.get_ticks_msec() / 1000.0
	if now - _last_boost_time < BOOST_COOLDOWN:
		return
	_last_boost_time = now
	match resource_type:
		"wood":
			GameState.add_wood(BOOST_AMOUNT)
		"food":
			GameState.add_food(BOOST_AMOUNT)
	_spawn_boost_text()

func _spawn_boost_text() -> void:
	var text: Label3D = FLOATING_TEXT_SCENE.instantiate()
	text.text = "+%d %s" % [BOOST_AMOUNT, resource_type]
	add_child(text)
