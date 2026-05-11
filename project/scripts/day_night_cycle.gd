# Drives the day/night cycle. Cosmetic only per VERTICAL_SLICE_PRD.md §2 —
# no mechanical effect on production, hunger, etc. in slice 1.
#
# time_of_day is a float ∈ [0, 1):
#   0.00  midnight
#   0.25  dawn
#   0.50  noon
#   0.75  dusk
#
# Each frame this script:
#   - advances time_of_day by delta / day_length_seconds
#   - rotates the Sun's X axis (full 360° per day)
#   - lerps sky / ambient color + energy between night/day extremes based
#     on a sinusoidal "brightness" curve that peaks at noon, zeroes at
#     midnight
#
# When time wraps past 1.0 the day_count increments and EventBus.day_changed
# fires so listeners (TopBar, future autosave, future seasons) can react.
extends Node

@export var sun_path: NodePath
@export var environment_path: NodePath

# 4 minutes per in-game day for slice tuning; can stretch later for longer
# observation of the cycle.
@export var day_length_seconds: float = 240.0

var sun: DirectionalLight3D
var environment_node: WorldEnvironment

const SKY_DAY: Color = Color(0.48, 0.66, 0.88)
const SKY_NIGHT: Color = Color(0.06, 0.08, 0.16)
const AMBIENT_DAY: Color = Color(0.95, 0.84, 0.7)
const AMBIENT_NIGHT: Color = Color(0.2, 0.25, 0.4)

const SUN_ENERGY_DAY: float = 1.05
const SUN_ENERGY_NIGHT: float = 0.0
const AMBIENT_ENERGY_DAY: float = 0.55
const AMBIENT_ENERGY_NIGHT: float = 0.15

func _ready() -> void:
	if not sun_path.is_empty():
		sun = get_node(sun_path)
	if not environment_path.is_empty():
		environment_node = get_node(environment_path)
	_apply(GameState.time_of_day)

func _process(delta: float) -> void:
	GameState.time_of_day += delta / day_length_seconds
	while GameState.time_of_day >= 1.0:
		GameState.time_of_day -= 1.0
		GameState.day_count += 1
		EventBus.day_changed.emit(GameState.day_count)
	_apply(GameState.time_of_day)

func _apply(t: float) -> void:
	# Sun rotation: t=0 → -90° (sun below), t=0.5 → +90° (overhead), full sweep.
	# We rotate around the sun's local X. Sun's -Z is "down toward ground" when
	# rotated -45° from horizontal etc. Simple sweep is good enough for cosmetic.
	if sun != null:
		sun.rotation_degrees = Vector3(-90.0 + t * 360.0, -30.0, 0.0)
	# Brightness peaks at noon (t=0.5), zero at midnight (t=0 or 1).
	# sin(t*TAU - PI/2) yields -1 at t=0, +1 at t=0.5.
	var brightness: float = clamp(sin(t * TAU - PI * 0.5) * 0.5 + 0.5, 0.0, 1.0)
	if sun != null:
		sun.light_energy = lerpf(SUN_ENERGY_NIGHT, SUN_ENERGY_DAY, brightness)
	if environment_node == null or environment_node.environment == null:
		return
	var env: Environment = environment_node.environment
	env.ambient_light_color = AMBIENT_NIGHT.lerp(AMBIENT_DAY, brightness)
	env.ambient_light_energy = lerpf(AMBIENT_ENERGY_NIGHT, AMBIENT_ENERGY_DAY, brightness)
	if env.sky != null and env.sky.sky_material is ProceduralSkyMaterial:
		var sky_mat: ProceduralSkyMaterial = env.sky.sky_material
		sky_mat.sky_horizon_color = SKY_NIGHT.lerp(SKY_DAY, brightness)
