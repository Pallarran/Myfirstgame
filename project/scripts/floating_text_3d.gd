# Short-lived floating text used for transient world feedback
# (e.g., the "+2 wood" pop above a building when click-to-boost lands).
#
# Note: this is NOT a violation of the villagers-are-anonymous rule.
# That rule is about persistent per-unit identity (names, traits, etc.).
# This is a one-second feedback burst that's universally readable.
extends Label3D

const RISE_HEIGHT: float = 1.6
const DURATION: float = 1.0

var _elapsed: float = 0.0
var _start_local_y: float = 0.0

func _ready() -> void:
	_start_local_y = position.y

func _process(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= DURATION:
		queue_free()
		return
	var t: float = _elapsed / DURATION
	position.y = _start_local_y + RISE_HEIGHT * t
	# Ease-out alpha — fade gently at start, faster near the end.
	modulate.a = 1.0 - (t * t)
