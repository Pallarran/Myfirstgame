# Data definition for a single building form within a lineage.
#
# A "form" is one identity in a lineage's progression (e.g., "Woodcutter's
# Lean-to" is Form 1 of the Forest — Wood lineage; later forms are Lodge,
# Sawmill, etc.). Each form has 5 visible levels with progressive output and
# visual upgrades.
#
# Saved as .tres files in project/data/forms/. Lineages reference these.
#
# Following CLAUDE.md "Data over code" — costs, production, level multipliers
# live here, not hardcoded in scripts.
@tool
class_name Form
extends Resource

@export var display_name: String = "Form"
@export_file("*.tscn") var building_scene_path: String = ""
@export_file("*.tscn") var camouflage_scene_path: String = ""

# --- Construction ---
@export var wood_cost: int = 20  # cost to first build this form at level 1

# --- Levels (per form) ---
# Level 1 is the base; level 5 is the peak. Output scales with the
# multiplier; the next-form evolution can fire when at level 5 (later slices).
@export var level_up_costs: Array[int] = [5, 10, 15, 20]  # 1→2, 2→3, 3→4, 4→5
@export var level_output_multipliers: Array[float] = [1.0, 1.25, 1.5, 1.75, 2.0]

# --- Behavior flags ---
@export var housing_provided: int = 0       # added to max_population on build
@export var attracts_villager: bool = false # spawns an immigrant on build

# --- Workers + production (gathering forms) ---
@export var max_workers: int = 0            # 0 means no worker UI
@export_enum("none", "wood", "food", "water") var produces: String = "none"
@export var production_amount: int = 1
@export var production_interval: float = 8.0
