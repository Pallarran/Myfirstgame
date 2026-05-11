# A single villager.
#
# Wanders around their spawn point on simple direct-movement AI — no
# pathfinding, no obstacle avoidance. Picks a random nearby ground point,
# walks there, pauses, picks another. Good enough for "the camp feels
# alive" until real jobs land in Milestone D.
#
# Villagers are anonymous in this project: no name, age, trait, or job
# surfaced anywhere. They're part of the population number — not
# individuals the player tracks. See memory: villagers-are-anonymous.
extends Node3D

@export var walk_speed: float = 1.5
@export var wander_radius: float = 10.0

# Pause range between wander legs, in seconds.
const PAUSE_RANGE: Vector2 = Vector2(1.0, 3.5)
# Stay inside roughly the playable area so villagers don't drift off the map.
const MAP_HALF_EXTENT: float = 13.0

var _target: Vector3
var _pause_remaining: float = 0.0
var _spawn_origin: Vector3

func _ready() -> void:
	_spawn_origin = position
	_pick_new_target()

func _process(delta: float) -> void:
	if _pause_remaining > 0.0:
		_pause_remaining -= delta
		return
	var to_target: Vector3 = _target - position
	to_target.y = 0.0
	if to_target.length() < 0.15:
		_pause_remaining = randf_range(PAUSE_RANGE.x, PAUSE_RANGE.y)
		_pick_new_target()
		return
	var direction: Vector3 = to_target.normalized()
	position += direction * walk_speed * delta
	# Face the direction of travel so the placeholder body visibly turns.
	var look_target: Vector3 = position + direction
	look_at(Vector3(look_target.x, position.y, look_target.z), Vector3.UP)

func _pick_new_target() -> void:
	var angle: float = randf() * TAU
	var radius: float = randf_range(2.0, wander_radius)
	_target = _spawn_origin + Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)
	_target.x = clamp(_target.x, -MAP_HALF_EXTENT, MAP_HALF_EXTENT)
	_target.z = clamp(_target.z, -MAP_HALF_EXTENT, MAP_HALF_EXTENT)
