# Light tutorial — three progress-triggered prompt cards per
# VERTICAL_SLICE_PRD.md §2 ("Tutorial: very light. Three or four prompt
# cards that appear as triggered by progress").
#
# Sequence:
#   1. Welcome (auto, ~2s after game start)
#   2. Workers (fires on first non-Heart building constructed)
#   3. Boost  (fires on first worker assigned anywhere)
#
# Each prompt shows a centered card; player dismisses with "Got it" or
# Esc. Once a stage is shown, it never repeats (single-session tutorial).
extends Control

const WELCOME_DELAY: float = 2.0

var _stage: int = 0  # 0=not shown, 1=welcome shown, 2=workers shown, 3=boost shown

@onready var _panel: Control = $Panel
@onready var _label: Label = $Panel/Margin/VBox/PromptLabel
@onready var _dismiss: Button = $Panel/Margin/VBox/Dismiss

func _ready() -> void:
	_panel.visible = false
	_dismiss.pressed.connect(_on_dismissed)
	EventBus.building_constructed.connect(_on_building_constructed)
	EventBus.workers_changed.connect(_on_workers_changed)
	# Don't trigger from the Heart auto-build at game start. We wait
	# WELCOME_DELAY seconds, then show the first prompt — by then Heart
	# has already fired its construction signal so the second-stage trigger
	# only catches subsequent buildings.
	await get_tree().create_timer(WELCOME_DELAY).timeout
	_show_stage(1, "Welcome to your camp.\nThe yellow squares are buildable plots — click one to begin.")

func _show_stage(stage: int, text: String) -> void:
	if stage <= _stage:
		return
	_stage = stage
	_label.text = text
	_panel.visible = true

func _on_dismissed() -> void:
	_panel.visible = false

func _on_building_constructed(_form_display_name: String) -> void:
	if _stage < 2:
		_show_stage(2, "Buildings need workers to produce.\nClick the + button on the floating panel.")

func _on_workers_changed(assigned: int, _total: int) -> void:
	if _stage < 3 and assigned > 0:
		_show_stage(3, "Your worker is producing.\nClick the building itself for a small boost.")

func _unhandled_input(event: InputEvent) -> void:
	if _panel.visible and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		_on_dismissed()
