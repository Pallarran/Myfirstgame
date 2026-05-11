# Gentle, fading notification feed for the world HUD.
#
# Sits in the bottom-left and listens to EventBus for meaningful events
# (building constructed / leveled up, villager arrived, hunger state
# changes, day change). Each notification is a small panel that appears
# at the top of the stack, lives DISPLAY_SECONDS, then fades and frees.
#
# Resource changes (wood/food/water/workers) are NOT surfaced here —
# they tick constantly and would drown out the real signal.
extends Control

const DISPLAY_SECONDS: float = 4.0
const FADE_SECONDS: float = 0.6
const MAX_VISIBLE: int = 5

@onready var _stack: VBoxContainer = $Stack

var _last_hungry: int = 0

func _ready() -> void:
	EventBus.building_constructed.connect(_on_building_constructed)
	EventBus.building_leveled_up.connect(_on_building_leveled_up)
	EventBus.villager_arrived.connect(_on_villager_arrived)
	EventBus.hungry_changed.connect(_on_hungry_changed)
	EventBus.day_changed.connect(_on_day_changed)

func _on_building_constructed(form_display_name: String) -> void:
	_push("%s built" % form_display_name)

func _on_building_leveled_up(form_display_name: String, new_level: int) -> void:
	_push("%s upgraded to Level %d" % [form_display_name, new_level])

func _on_villager_arrived() -> void:
	_push("A new villager has arrived")

func _on_hungry_changed(count: int) -> void:
	# Only surface meaningful transitions: someone started being hungry, or
	# everyone is fed again. Tick-by-tick hunger noise is suppressed.
	if count > _last_hungry and count > 0:
		_push("%d villager%s hungry" % [count, "s are" if count > 1 else " is"])
	elif count == 0 and _last_hungry > 0:
		_push("Everyone is fed")
	_last_hungry = count

func _on_day_changed(new_day: int) -> void:
	_push("Day %d dawns" % new_day)

func _push(text: String) -> void:
	# Cap the stack so cold-starts (with Heart auto-build firing a
	# notification) don't pile up beyond what fits.
	while _stack.get_child_count() >= MAX_VISIBLE:
		var oldest: Node = _stack.get_child(_stack.get_child_count() - 1)
		oldest.queue_free()
	var panel: PanelContainer = _build_notification_panel(text)
	_stack.add_child(panel)
	_stack.move_child(panel, 0)  # newest on top
	_schedule_fade(panel)

func _build_notification_panel(text: String) -> PanelContainer:
	var panel := PanelContainer.new()
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.13, 0.16, 0.88)
	style.border_width_left = 1
	style.border_width_top = 1
	style.border_width_right = 1
	style.border_width_bottom = 1
	style.border_color = Color(0.35, 0.3, 0.22, 1.0)
	style.corner_radius_top_left = 6
	style.corner_radius_top_right = 6
	style.corner_radius_bottom_left = 6
	style.corner_radius_bottom_right = 6
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 6
	style.content_margin_bottom = 6
	panel.add_theme_stylebox_override("panel", style)
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 14)
	label.add_theme_color_override("font_color", Color(0.92, 0.88, 0.78, 1.0))
	panel.add_child(label)
	return panel

func _schedule_fade(node: Node) -> void:
	var tween := create_tween()
	tween.tween_interval(DISPLAY_SECONDS)
	tween.tween_property(node, "modulate:a", 0.0, FADE_SECONDS)
	tween.tween_callback(node.queue_free)
