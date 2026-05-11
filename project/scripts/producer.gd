# Shared script for gathering buildings (Woodcutter, Forager).
#
# Drives auto-production on a fixed cadence: every `production_interval`
# seconds, adds `production_amount` of `resource_type` to GameState. No
# worker assignment yet (Milestone D-2); current behavior is auto-tick.
#
# Each building scene sets the three exported values on its root node.
extends Node3D

@export_enum("wood", "food") var resource_type: String = "wood"
@export var production_amount: int = 1
@export var production_interval: float = 8.0

var _accumulator: float = 0.0

func _process(delta: float) -> void:
	_accumulator += delta
	if _accumulator >= production_interval:
		_accumulator -= production_interval
		match resource_type:
			"wood":
				GameState.add_wood(production_amount)
			"food":
				GameState.add_food(production_amount)
