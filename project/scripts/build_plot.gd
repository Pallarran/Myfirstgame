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

@onready var _marker: MeshInstance3D = $Marker
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

# Spawn the current form's building scene as a child of this plot. Hides the
# unbuilt marker/hover/click visuals. Returns the spawned instance so callers
# can wire signals (workers_changed, etc.).
func build_form() -> Node3D:
	var form: Form = current_form()
	if form == null:
		return null
	var scene: PackedScene = load(form.building_scene_path)
	if scene == null:
		return null
	var building: Node3D = scene.instantiate()
	add_child(building)
	# Apply the plot's facing rotation per MAP_SPECIFICATION.md §6
	# (Buildings face Heart on periphery, resource buildings face their
	# resource, Sacred Height faces Heart, defense faces outward, etc.).
	building.rotation_degrees.y = orientation_yaw_deg
	current_building_instance = building
	current_level = 1
	activation_state = "Built"
	_set_unbuilt_visuals_visible(false)
	# Camouflage: persistent props that fill the plot's reserved space at
	# small forms (MAP_SPECIFICATION.md §5). Same lifetime as the building,
	# and inherits orientation so props stay on the correct side.
	if form.camouflage_scene_path != "":
		var cam_scene: PackedScene = load(form.camouflage_scene_path)
		if cam_scene != null:
			var cam: Node3D = cam_scene.instantiate()
			add_child(cam)
			cam.rotation_degrees.y = orientation_yaw_deg
			current_camouflage_instance = cam
	# Wire the level-up signal into the building's set_level so visual
	# layers toggle as the player upgrades. Sync the initial state.
	if building.has_method("set_level"):
		level_changed.connect(building.set_level)
		building.set_level(current_level)
	return building

# Player-driven level up. Spends wood per the form's level_up_costs. Returns
# true on success. Emits level_changed so listeners (visual swapper, producer
# scaling refresh) can react.
func try_level_up() -> bool:
	if current_level >= 5:
		return false
	var form: Form = current_form()
	if form == null:
		return false
	if current_level - 1 >= form.level_up_costs.size():
		return false
	var cost: int = form.level_up_costs[current_level - 1]
	if not GameState.spend_wood(cost):
		return false
	current_level += 1
	level_changed.emit(current_level)
	EventBus.building_leveled_up.emit(form.display_name, current_level)
	AudioManager.play_sfx("level_up")
	return true

# Output multiplier for the current level, looked up from the form's array.
# Clamps to the array's bounds for safety.
func current_level_multiplier() -> float:
	var form: Form = current_form()
	if form == null or form.level_output_multipliers.is_empty():
		return 1.0
	var idx: int = clampi(current_level - 1, 0, form.level_output_multipliers.size() - 1)
	return form.level_output_multipliers[idx]

# Cost of advancing to the next level. Returns -1 if at max or unavailable.
func next_level_up_cost() -> int:
	if current_level >= 5:
		return -1
	var form: Form = current_form()
	if form == null:
		return -1
	if current_level - 1 >= form.level_up_costs.size():
		return -1
	return form.level_up_costs[current_level - 1]

func _set_unbuilt_visuals_visible(value: bool) -> void:
	if _marker != null:
		_marker.visible = value
	if _hover != null:
		_hover.visible = false  # hover state is dynamic; reset on built
	if _area != null:
		_area.input_ray_pickable = value

func _on_area_input(_camera: Node, event: InputEvent, _pos: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit(self)

func _on_mouse_entered() -> void:
	_hover.visible = true

func _on_mouse_exited() -> void:
	_hover.visible = false
