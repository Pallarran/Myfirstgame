# A compact panel that floats above a gathering building, showing the
# worker count and offering inline +/- buttons. No modal — visible
# at all times once the building exists.
#
# Lives in the world's HUD CanvasLayer. Each gathering building gets its
# own panel instanced and bound via `bind_to(building)` from world.gd.
# Position is computed every frame from the building's world position
# (a fixed y-offset above the structure, then unprojected to screen).
#
# Buttons are gated on:
#   +  disabled if building is at max workers OR no idle population.
#   −  disabled if building has 0 workers.
extends Control

# Vertical offset (in world units) above the building's origin where the
# panel anchors. The buildings are scaled 7x and stand on the ground;
# 4.0 lands the panel comfortably above their tops.
const ANCHOR_HEIGHT: float = 4.0

var _building: Node3D = null

@onready var _minus: Button = $Panel/HBox/Minus
@onready var _label: Label = $Panel/HBox/Label
@onready var _plus: Button = $Panel/HBox/Plus

func _ready() -> void:
	_minus.pressed.connect(_on_minus_pressed)
	_plus.pressed.connect(_on_plus_pressed)
	EventBus.workers_changed.connect(_on_workers_changed)
	EventBus.population_changed.connect(_on_population_changed)

func bind_to(building: Node3D) -> void:
	_building = building
	_refresh()

func _process(_delta: float) -> void:
	if not is_instance_valid(_building):
		queue_free()
		return
	var camera: Camera3D = get_viewport().get_camera_3d()
	if camera == null:
		return
	var world_anchor: Vector3 = _building.global_position + Vector3(0.0, ANCHOR_HEIGHT, 0.0)
	if camera.is_position_behind(world_anchor):
		visible = false
		return
	visible = true
	var screen_pos: Vector2 = camera.unproject_position(world_anchor)
	position = (screen_pos - size * 0.5).round()

func _refresh() -> void:
	if _building == null:
		return
	_label.text = "%d / %d" % [_building.current_workers, _building.max_workers]
	_plus.disabled = _building.current_workers >= _building.max_workers or GameState.idle_population() <= 0
	_minus.disabled = _building.current_workers <= 0

func _on_workers_changed(_assigned: int, _total: int) -> void:
	_refresh()

func _on_population_changed(_current: int, _max: int) -> void:
	_refresh()

func _on_plus_pressed() -> void:
	if _building != null:
		_building.try_assign()

func _on_minus_pressed() -> void:
	if _building != null:
		_building.try_unassign()
