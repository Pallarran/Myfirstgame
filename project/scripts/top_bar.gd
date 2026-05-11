# Persistent resource readout pinned to the top of the screen.
#
# Listens to `EventBus` for resource-change signals and refreshes its labels.
# Pulls the initial values from `GameState` on _ready so the bar is correct
# even if no signals have fired yet (e.g. fresh game).
extends Control

@onready var _wood_label: Label = $Panel/Margin/HBox/WoodLabel
@onready var _food_label: Label = $Panel/Margin/HBox/FoodLabel
@onready var _pop_label: Label = $Panel/Margin/HBox/PopLabel
@onready var _idle_label: Label = $Panel/Margin/HBox/IdleLabel
@onready var _hungry_label: Label = $Panel/Margin/HBox/HungryLabel

func _ready() -> void:
	EventBus.wood_changed.connect(_on_wood_changed)
	EventBus.food_changed.connect(_on_food_changed)
	EventBus.population_changed.connect(_on_population_changed)
	EventBus.workers_changed.connect(_on_workers_changed)
	EventBus.hungry_changed.connect(_on_hungry_changed)
	_on_wood_changed(GameState.wood)
	_on_food_changed(GameState.food)
	_on_population_changed(GameState.current_population, GameState.max_population)
	_refresh_idle()
	_on_hungry_changed(GameState.current_hungry)

func _on_wood_changed(new_amount: int) -> void:
	_wood_label.text = "Wood: %d" % new_amount

func _on_food_changed(new_amount: int) -> void:
	_food_label.text = "Food: %d" % new_amount

func _on_population_changed(current_pop: int, max_pop: int) -> void:
	_pop_label.text = "Pop: %d / %d" % [current_pop, max_pop]
	_refresh_idle()

func _on_workers_changed(_assigned: int, _total: int) -> void:
	_refresh_idle()

func _refresh_idle() -> void:
	_idle_label.text = "Idle: %d" % GameState.idle_population()

func _on_hungry_changed(count: int) -> void:
	# Hide the label when nobody's hungry — quieter UI in the steady state.
	_hungry_label.visible = count > 0
	_hungry_label.text = "Hungry: %d" % count
