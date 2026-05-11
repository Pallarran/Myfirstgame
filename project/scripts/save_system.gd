# Save / load orchestrator. Autoload singleton.
#
# JSON-based save at `user://savegame.json` (Godot's per-user data dir).
# Per CLAUDE.md "Saves: JSON-based. Each system serializes its own state.
# Save format versioned from day one."
#
# What gets saved in slice 1:
#   - GameState fields (resources, population counts, time, day)
#   - Per-plot: built? form index? level? worker count?
#
# What's NOT saved in slice 1:
#   - Individual villager positions (count is reconstructed; they wander
#     from default spawn positions on load)
#   - Per-villager hunger state (rebuilt on next food tick)
#   - Wander targets (each villager picks new ones on load)
#
# Load flow:
#   1. Caller (Main Menu Continue, or load hotkey) calls load_file().
#   2. SaveSystem stores the parsed dict in `_pending_load`.
#   3. Caller switches to world.tscn.
#   4. world.gd._ready checks `consume_pending_load()` and applies it
#      AFTER its normal setup.
extends Node

const SAVE_PATH: String = "user://savegame.json"
const SAVE_VERSION: int = 1

var _pending_load: Dictionary = {}

func save_exists() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_world(world: Node) -> bool:
	var data: Dictionary = {
		"version": SAVE_VERSION,
		"game_state": _serialize_game_state(),
	}
	if world != null and world.has_method("serialize_world"):
		data["world"] = world.serialize_world()
	var json: String = JSON.stringify(data, "  ")
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_warning("SaveSystem: could not open %s for writing" % SAVE_PATH)
		return false
	file.store_string(json)
	return true

# Reads the save file into _pending_load. Returns true if a usable save
# was found. Caller then switches the scene to world.tscn, which picks
# up the pending data in _ready.
func load_file() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file: FileAccess = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return false
	var text: String = file.get_as_text()
	var parsed: Variant = JSON.parse_string(text)
	if not (parsed is Dictionary):
		push_warning("SaveSystem: malformed save file")
		return false
	var data: Dictionary = parsed
	if data.get("version", 0) != SAVE_VERSION:
		push_warning("SaveSystem: incompatible save version %s" % data.get("version", 0))
		return false
	_pending_load = data
	return true

func consume_pending_load() -> Dictionary:
	var d: Dictionary = _pending_load
	_pending_load = {}
	return d

# --- GameState serialization --------------------------------------------

func _serialize_game_state() -> Dictionary:
	return {
		"wood": GameState.wood,
		"food": GameState.food,
		"water": GameState.water,
		"current_population": GameState.current_population,
		"max_population": GameState.max_population,
		"workers_assigned": GameState.workers_assigned,
		"current_hungry": GameState.current_hungry,
		"time_of_day": GameState.time_of_day,
		"day_count": GameState.day_count,
	}

# Restore GameState fields. Emits all the relevant EventBus signals so
# subscribed UI (TopBar, etc.) refreshes.
func apply_game_state(d: Dictionary) -> void:
	if d.is_empty():
		return
	GameState.wood = int(d.get("wood", GameState.STARTING_WOOD))
	GameState.food = int(d.get("food", GameState.STARTING_FOOD))
	GameState.water = int(d.get("water", GameState.STARTING_WATER))
	GameState.current_population = int(d.get("current_population", GameState.STARTING_POPULATION))
	GameState.max_population = int(d.get("max_population", GameState.CAMPFIRE_HOUSING))
	GameState.workers_assigned = int(d.get("workers_assigned", 0))
	GameState.current_hungry = int(d.get("current_hungry", 0))
	GameState.time_of_day = float(d.get("time_of_day", 0.3))
	GameState.day_count = int(d.get("day_count", 1))
	EventBus.wood_changed.emit(GameState.wood)
	EventBus.food_changed.emit(GameState.food)
	EventBus.water_changed.emit(GameState.water)
	EventBus.population_changed.emit(GameState.current_population, GameState.max_population)
	EventBus.workers_changed.emit(GameState.workers_assigned, GameState.current_population)
	EventBus.hungry_changed.emit(GameState.current_hungry)
