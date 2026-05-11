# Camera rig for the diorama-style world view.
#
# Attach this script to a CameraRig (Node3D). Expected child structure:
#   CameraRig (Node3D, this)   <-- yaw around world up; also the pan target
#   └── CameraArm (Node3D)     <-- pitch (tilt)
#       └── Camera (Camera3D)  <-- zoom via local Z offset (further back = zoomed out)
#
# Controls:
#   Right-click drag — orbit (yaw + pitch)
#   Mouse wheel      — zoom
#   WASD / arrows    — pan along the ground plane, camera-relative
#
# The rig sits at ground level; the arm tilts down so the camera looks at the
# rig's origin from above. Pitch is clamped so the player can't look straight
# up or fully overhead.
extends Node3D

const PAN_SPEED: float = 12.0                # world units per second
const ORBIT_SENSITIVITY: float = 0.005       # radians per pixel of mouse motion
const ZOOM_STEP: float = 1.5                 # world units per scroll tick
const MIN_ZOOM: float = 5.0                  # closest the camera can get
const MAX_ZOOM: float = 40.0                 # furthest the camera can get
const MIN_PITCH: float = -1.40               # ~-80 degrees (nearly straight down)
const MAX_PITCH: float = -0.26               # ~-15 degrees (low, almost horizontal)
const PAN_BOUND: float = 30.0                # half-extent of the playable area; keep camera near map
const INITIAL_PITCH: float = -PI / 4.0       # -45 degrees: classic diorama tilt

@onready var _arm: Node3D = $CameraArm
@onready var _camera: Camera3D = $CameraArm/Camera

var _orbiting: bool = false

func _ready() -> void:
	_arm.rotation.x = INITIAL_PITCH

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_orbiting = event.pressed
			# Capture the mouse while orbiting so the cursor doesn't leave the window.
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if _orbiting else Input.MOUSE_MODE_VISIBLE
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			_zoom(-ZOOM_STEP)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			_zoom(ZOOM_STEP)
	elif event is InputEventMouseMotion and _orbiting:
		rotation.y -= event.relative.x * ORBIT_SENSITIVITY
		_arm.rotation.x = clamp(
			_arm.rotation.x - event.relative.y * ORBIT_SENSITIVITY,
			MIN_PITCH,
			MAX_PITCH
		)

func _process(delta: float) -> void:
	var pan_input: Vector2 = Vector2.ZERO
	# +Y = forward (camera-relative). W/Up = forward, S/Down = backward.
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		pan_input.y += 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		pan_input.y -= 1.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		pan_input.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		pan_input.x += 1.0
	if pan_input != Vector2.ZERO:
		_pan(pan_input.normalized(), delta)

func _pan(direction_2d: Vector2, delta: float) -> void:
	# Move in the rig's local XZ plane, ignoring its tilt so panning stays flat.
	var forward: Vector3 = -transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()
	var right: Vector3 = transform.basis.x
	right.y = 0.0
	right = right.normalized()
	var movement: Vector3 = (right * direction_2d.x + forward * direction_2d.y) * PAN_SPEED * delta
	position += movement
	position.x = clamp(position.x, -PAN_BOUND, PAN_BOUND)
	position.z = clamp(position.z, -PAN_BOUND, PAN_BOUND)

func _zoom(amount: float) -> void:
	_camera.position.z = clamp(_camera.position.z + amount, MIN_ZOOM, MAX_ZOOM)
