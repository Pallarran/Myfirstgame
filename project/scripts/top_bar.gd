# Persistent resource readout pinned to the top of the screen.
#
# Listens to `EventBus` for resource-change signals and refreshes its labels.
# Pulls the initial values from `GameState` on _ready so the bar is correct
# even if no signals have fired yet (e.g. fresh game).
extends Control

@onready var _wood_label: Label = $Panel/Margin/HBox/WoodLabel
@onready var _pop_label: Label = $Panel/Margin/HBox/PopLabel

func _ready() -> void:
	EventBus.wood_changed.connect(_on_wood_changed)
	EventBus.population_changed.connect(_on_population_changed)
	_on_wood_changed(GameState.wood)
	_on_population_changed(GameState.current_population, GameState.max_population)

func _on_wood_changed(new_amount: int) -> void:
	_wood_label.text = "Wood: %d" % new_amount

func _on_population_changed(current_pop: int, max_pop: int) -> void:
	_pop_label.text = "Pop: %d / %d" % [current_pop, max_pop]
