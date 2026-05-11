# Global signal hub.
#
# Systems that don't naturally own each other talk through this autoload
# instead of taking direct references. A producer emits on the bus; any
# number of listeners can connect. Adding a new cross-system signal is
# fine — just declare it here, and prefix it with @warning_ignore so Godot
# doesn't flag it as unused (the whole point is that this file never uses
# its own signals; emitters and listeners live elsewhere).
#
# Registered as an autoload (see project.godot [autoload] section) so it's
# globally accessible as `EventBus.<signal_name>`.
extends Node

# --- Resources -----------------------------------------------------------
@warning_ignore("unused_signal")
signal wood_changed(new_amount: int)

@warning_ignore("unused_signal")
signal food_changed(new_amount: int)

@warning_ignore("unused_signal")
signal water_changed(new_amount: int)

# --- Population ----------------------------------------------------------
@warning_ignore("unused_signal")
signal population_changed(current_pop: int, max_pop: int)

@warning_ignore("unused_signal")
signal workers_changed(assigned: int, total_pop: int)

@warning_ignore("unused_signal")
signal hungry_changed(count: int)
