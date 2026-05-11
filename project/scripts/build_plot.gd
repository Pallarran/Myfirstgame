# A pre-designated building plot on the map.
#
# Players never place buildings freely (design pillar #2 — "No spatial puzzle").
# They choose *what* and *when*; *where* is decided here in the scene by us.
#
# Behavior:
#   - Hover: shows a subtle highlight rectangle over the marker.
#   - Click: emits `clicked(self)` so the world can react (open build menu).
#
# Building info is currently hardcoded constants (Tent only). When the slice
# adds Woodcutter and Forager, this should move to a BuildingType resource
# catalog in project/data/buildings/*.tres, per CLAUDE.md "Data over code".
extends Node3D

signal clicked(plot: Node3D)

const BUILDING_NAME: String = "Tent"
const BUILDING_COST: int = 20
const BUILDING_SCENE_PATH: String = "res://scenes/buildings/tent.tscn"

@onready var _hover: MeshInstance3D = $HoverHighlight
@onready var _area: Area3D = $ClickArea

func _ready() -> void:
	_hover.visible = false
	_area.input_event.connect(_on_area_input)
	_area.mouse_entered.connect(_on_mouse_entered)
	_area.mouse_exited.connect(_on_mouse_exited)

func _on_area_input(_camera: Node, event: InputEvent, _pos: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)

func _on_mouse_entered() -> void:
	_hover.visible = true

func _on_mouse_exited() -> void:
	_hover.visible = false
