# Data definition for a plot lineage — a sequence of building forms a plot
# progresses through across the game.
#
# Example: the Housing lineage's forms are Tent → Wooden Cabin → Timber House
# → Stone Townhouse → Manor Wing. A plot tagged with this lineage starts at
# Form 1 (Tent) and evolves through them.
#
# In slice 1, every lineage's `forms` array has exactly one entry (Form 1).
# The data model already supports the rest for future slices.
#
# Saved as .tres files in project/data/lineages/.
@tool
class_name Lineage
extends Resource

@export var lineage_id: String = "unnamed"
@export var display_name: String = "Lineage"
@export_multiline var role: String = ""
@export var forms: Array[Form] = []
