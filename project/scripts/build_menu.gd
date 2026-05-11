# Modal panel shown when the player clicks a build plot.
#
# The menu reads the building name and cost from the plot itself, checks
# affordability via GameState, and stays in sync with wood changes (so if
# the player gains/loses wood while the menu is open, the Build button
# enables/disables live).
#
# Emits `confirmed(plot)` when the player clicks Build, `cancelled` when
# they click Cancel. The world script handles the actual construction
# (spend wood, swap the plot for the building) on confirmed.
extends Control

signal confirmed(plot: Node3D)
signal cancelled

var _plot: Node3D = null

@onready var _title_label: Label = $Panel/Margin/VBox/Title
@onready var _cost_label: Label = $Panel/Margin/VBox/Cost
@onready var _status_label: Label = $Panel/Margin/VBox/Status
@onready var _build_button: Button = $Panel/Margin/VBox/Buttons/BuildButton
@onready var _cancel_button: Button = $Panel/Margin/VBox/Buttons/CancelButton

func _ready() -> void:
	visible = false
	_build_button.pressed.connect(_on_build_pressed)
	_cancel_button.pressed.connect(_on_cancel_pressed)
	EventBus.wood_changed.connect(_on_wood_changed)

func open_for(plot: Node3D) -> void:
	_plot = plot
	_title_label.text = "Build %s" % plot.BUILDING_NAME
	_cost_label.text = "Cost: %d wood" % plot.BUILDING_COST
	_refresh_affordability()
	visible = true

func close_menu() -> void:
	visible = false
	_plot = null

func _refresh_affordability() -> void:
	if _plot == null:
		return
	var can_afford: bool = GameState.can_afford_wood(_plot.BUILDING_COST)
	_build_button.disabled = not can_afford
	_status_label.text = "" if can_afford else "Not enough wood."

func _on_wood_changed(_new_amount: int) -> void:
	_refresh_affordability()

func _on_build_pressed() -> void:
	if _plot != null:
		confirmed.emit(_plot)
	close_menu()

func _on_cancel_pressed() -> void:
	cancelled.emit()
	close_menu()

func _unhandled_input(event: InputEvent) -> void:
	# Pressing Esc while the menu is open just closes it instead of bouncing
	# back to the main menu. world.gd's Esc handler runs only on _unhandled_input,
	# so accepting the event here keeps it from propagating.
	if visible and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		_on_cancel_pressed()
