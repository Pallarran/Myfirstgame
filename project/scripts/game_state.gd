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

# --- Wood ----------------------------------------------------------------

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

# --- Food ----------------------------------------------------------------

const STARTING_FOOD: int = 30  # a small buffer so the camp doesn't starve on day 1

var food: int = STARTING_FOOD

func add_food(amount: int) -> void:
	if amount <= 0:
		return
	food += amount
	EventBus.food_changed.emit(food)

func spend_food(amount: int) -> bool:
	if amount <= 0 or food < amount:
		return false
	food -= amount
	EventBus.food_changed.emit(food)
	return true

func can_afford_food(amount: int) -> bool:
	return food >= amount

# --- Water ---------------------------------------------------------------

const STARTING_WATER: int = 0

var water: int = STARTING_WATER

func add_water(amount: int) -> void:
	if amount <= 0:
		return
	water += amount
	EventBus.water_changed.emit(water)

func spend_water(amount: int) -> bool:
	if amount <= 0 or water < amount:
		return false
	water -= amount
	EventBus.water_changed.emit(water)
	return true

func can_afford_water(amount: int) -> bool:
	return water >= amount

# --- Time of day --------------------------------------------------------
# Cosmetic only in slice 1 (VERTICAL_SLICE_PRD.md §2). time_of_day ∈ [0, 1):
# 0 = midnight, 0.25 = dawn, 0.5 = noon, 0.75 = dusk. Wraps at 1.0;
# day_count increments when it wraps.

var time_of_day: float = 0.3  # start mid-morning so first frame isn't dark
var day_count: int = 1

# --- Population ----------------------------------------------------------

# The Campfire houses the starting villagers; each Tent adds TENT_HOUSING.
# Hard cap of 8 matches VERTICAL_SLICE_PRD §2.
const STARTING_POPULATION: int = 3
const CAMPFIRE_HOUSING: int = 3
const TENT_HOUSING: int = 2
const POPULATION_HARD_CAP: int = 8

var current_population: int = STARTING_POPULATION
var max_population: int = CAMPFIRE_HOUSING

# Returns true if a new villager could be housed.
func add_villager() -> bool:
	if current_population >= max_population or current_population >= POPULATION_HARD_CAP:
		return false
	current_population += 1
	EventBus.population_changed.emit(current_population, max_population)
	return true

func add_housing(amount: int) -> void:
	if amount <= 0:
		return
	max_population = min(POPULATION_HARD_CAP, max_population + amount)
	EventBus.population_changed.emit(current_population, max_population)

# --- Workers -------------------------------------------------------------
# Tracking is count-based: how many of the current_population are assigned
# to some building. Villagers don't have per-unit identity (see memory:
# villagers-are-anonymous), so this is purely a global tally.

var workers_assigned: int = 0

func idle_population() -> int:
	return current_population - workers_assigned

func assign_worker() -> bool:
	if idle_population() <= 0:
		return false
	workers_assigned += 1
	EventBus.workers_changed.emit(workers_assigned, current_population)
	return true

func unassign_worker() -> bool:
	if workers_assigned <= 0:
		return false
	workers_assigned -= 1
	EventBus.workers_changed.emit(workers_assigned, current_population)
	return true

# --- Hunger --------------------------------------------------------------
# Count of villagers currently in the "hungry" state. Updated by the food
# tick in world.gd; surfaced via the TopBar.

var current_hungry: int = 0

func set_hungry_count(count: int) -> void:
	if count == current_hungry:
		return
	current_hungry = count
	EventBus.hungry_changed.emit(current_hungry)
