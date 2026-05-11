# Root script for non-producer form scenes (Tent, Campfire, Elder's Tent).
#
# Implements `set_level(level: int)` which toggles the visibility of child
# nodes named L2Props through L5Props. Level 1 has all higher-level
# prop containers hidden; each level reveals one more.
#
# The plot owns the level state; this script is the listener that the plot's
# `level_changed` signal hooks into via `level_changed.connect(building.set_level)`
# in build_plot.gd.
#
# Producer buildings (Woodcutter, Forager, Water Carrier Post) have their own
# root script (producer.gd) which implements the same set_level method —
# kept as parallel duck-typing rather than a shared base class for slice 1.
extends Node3D

func set_level(level: int) -> void:
	for i in range(2, 6):
		var node_name: String = "L%dProps" % i
		if has_node(node_name):
			get_node(node_name).visible = level >= i
