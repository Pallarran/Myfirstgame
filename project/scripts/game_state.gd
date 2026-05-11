# Single source of truth for mutable game state.
#
# Holds resource counts, population, time of day, and (later) any other state
# that the rest of the game reads against. Mutations should go through the
# `add_*` / `spend_*` methods rather than poking variables directly, so
# `EventBus` signals fire reliably and observers stay in sync.
#
# Registered as an autoload (see project.godot [autoload] section). Globally
# accessible as `GameState.wood`, `GameState.spend_wood(20)`, etc.
extends Node

const STARTING_WOOD: int = 25  # enough for one Tent at the current cost

var wood: int = STARTING_WOOD

func add_wood(amount: int) -> void:
	if amount <= 0:
		return
	wood += amount
	EventBus.wood_changed.emit(wood)

func spend_wood(amount: int) -> bool:
	if amount <= 0 or wood < amount:
		return false
	wood -= amount
	EventBus.wood_changed.emit(wood)
	return true

func can_afford_wood(amount: int) -> bool:
	return wood >= amount
