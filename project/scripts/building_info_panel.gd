# Modal panel shown when the player clicks a built gathering building
# (Woodcutter, Forager).
#
# Lets the player assign or unassign workers (count only — no per-villager
# identity, per memory: villagers-are-anonymous). +/- buttons are disabled
# when at the limit (no idle villagers to add; nobody assigned to remove).
# Shows the building's production rate as flavor.
#
# Stays in sync with GameState via EventBus.workers_changed so the button
# states update live if the panel is open while idle pop changes (e.g.,
# a tent finishing and bringing in a new immigrant).
extends Control

var _building: Node3D = null

@onready var _title: Label = $Panel/Margin/VBox/Title
@onready var _workers_label: Label = $Panel/Margin/VBox/Workers
@onready var _production_label: Label = $Panel/Margin/VBox/Production
@onready var _minus_button: Button = $Panel/Margin/VBox/Buttons/Minus
@onready var _plus_button: Button = $Panel/Margin/VBox/Buttons/Plus
@onready var _close_button: Button = $Panel/Margin/VBox/CloseButton

func _ready() -> void:
	visible = false
	_minus_button.pressed.connect(_on_minus_pressed)
	_plus_button.pressed.connect(_on_plus_pressed)
	_close_button.pressed.connect(close_panel)
	EventBus.workers_changed.connect(_on_workers_changed)
	EventBus.population_changed.connect(_on_population_changed)

func open_for(building: Node3D) -> void:
	_building = building
	_title.text = _building_display_name(building)
	_production_label.text = "Produces: 1 %s every %.0fs (per worker)" % [
		building.resource_type, building.production_interval
	]
	_refresh()
	visible = true

func close_panel() -> void:
	visible = false
	_building = null

func _refresh() -> void:
	if _building == null:
		return
	_workers_label.text = "Workers:  %d / %d" % [_building.current_workers, _building.max_workers]
	_plus_button.disabled = _building.current_workers >= _building.max_workers or GameState.idle_population() <= 0
	_minus_button.disabled = _building.current_workers <= 0

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

func _building_display_name(building: Node3D) -> String:
	# Buildings are scenes named after their type; "Woodcutter" → "Woodcutter's lean-to" feels nicer.
	match building.name:
		"Woodcutter":
			return "Woodcutter's lean-to"
		"Forager":
			return "Forager's hut"
		_:
			return building.name

func _unhandled_input(event: InputEvent) -> void:
	if visible and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		close_panel()
