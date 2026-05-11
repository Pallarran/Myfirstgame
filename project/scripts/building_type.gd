# Data definition for a buildable structure.
#
# Saved as .tres files in project/data/buildings/. Each BuildPlot
# references one of these via @export to know what gets built there.
# Following CLAUDE.md's "Data over code" — building costs, housing,
# production rates live here rather than hardcoded in scripts.
#
# Resource-typed exports give us autocomplete in the editor and let
# Godot serialize/deserialize cleanly.
@tool
class_name BuildingType
extends Resource

@export var display_name: String = "Building"
@export var wood_cost: int = 20
@export_file("*.tscn") var building_scene_path: String = ""

# Housing-related
@export var housing_provided: int = 0
@export var attracts_villager: bool = false

# Production-related (Milestone D)
@export_enum("none", "wood", "food") var produces: String = "none"
@export var production_amount: int = 1   # how much is produced per tick
@export var production_interval: float = 8.0  # seconds between ticks
