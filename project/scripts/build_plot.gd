# A pre-designated building plot on the map.
#
# Players never place buildings freely (design pillar #3 — "No spatial puzzle").
# They choose *what* and *when*; *where* is decided here in the scene by us.
#
# Each plot scene instance carries a `lineage` Resource reference that defines
# the sequence of forms a plot progresses through (slice 1: lineage has one
# form only). At build time, the plot reads `lineage.forms[current_form_index]`
# to know what to instantiate.
#
# Anchor-and-grow per MAP_SPECIFICATION.md §5: the anchor is sacred. Buildings
# grow outward from this point; reserved_footprint reserves the space needed
# for the largest form in the lineage; camouflage props fill empty space at
# small forms (camouflage instantiation lands in R-4).
#
# Behavior:
#   - Hover: subtle highlight rectangle over the marker.
#   - Click: emits `clicked(self)` so the world can react (open build menu).
extends Node3D

signal clicked(plot: Node3D)
signal level_changed(new_level: int)

@export var lineage: Lineage
# Local-space anchor (relative to plot origin). Most plots use ZERO.
@export var anchor_position: Vector3 = Vector3.ZERO
# Max footprint reserved on the ground for this plot's largest form.
@export var reserved_footprint: Vector2 = Vector2(8.0, 8.0)
# Building rotation around Y, in degrees. Resolved at build time.
@export var orientation_yaw_deg: float = 0.0

# Runtime state (not exported — set by build flow).
var activation_state: String = "Activatable"  # "Activatable" | "Built"
var current_form_index: int = 0
var current_level: int = 1
var current_building_instance: Node3D = null
var current_camouflage_instance: Node3D = null

@onready var _hover: MeshInstance3D = $HoverHighlight
@onready var _area: Area3D = $ClickArea

func _ready() -> void:
	_hover.visible = false
	_area.input_event.connect(_on_area_input)
	_area.mouse_entered.connect(_on_mouse_entered)
	_area.mouse_exited.connect(_on_mouse_exited)

# Returns the currently-relevant Form resource, or null if lineage isn't set.
func current_form() -> Form:
	if lineage == null or lineage.forms.is_empty():
		return null
	return lineage.forms[current_form_index]

func _on_area_input(_camera: Node, event: InputEvent, _pos: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)

func _on_mouse_entered() -> void:
	_hover.visible = true

func _on_mouse_exited() -> void:
	_hover.visible = false
