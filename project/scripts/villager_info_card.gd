# Modal panel shown when the player clicks a villager.
#
# Displays the villager's name, age, trait, and current job. No actions
# yet — it's a read-only window. Closes via the X button or Esc.
#
# Traits and jobs are cosmetic in this slice; mechanical effects (job
# productivity, trait-tied movement speed, etc.) come in later milestones.
extends Control

@onready var _title: Label = $Panel/Margin/VBox/Title
@onready var _age_label: Label = $Panel/Margin/VBox/Age
@onready var _trait_label: Label = $Panel/Margin/VBox/Trait
@onready var _job_label: Label = $Panel/Margin/VBox/Job
@onready var _close_button: Button = $Panel/Margin/VBox/CloseButton

func _ready() -> void:
	visible = false
	_close_button.pressed.connect(close_card)

func open_for(villager: Node3D) -> void:
	_title.text = villager.villager_name
	_age_label.text = "Age:  %d" % villager.villager_age
	_trait_label.text = "Trait:  %s" % villager.villager_trait
	_job_label.text = "Job:  %s" % villager.villager_job
	visible = true

func close_card() -> void:
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	# Esc closes the card without bouncing back to the main menu.
	if visible and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		close_card()
