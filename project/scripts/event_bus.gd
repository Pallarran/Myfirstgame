# Global signal hub.
#
# Systems that don't naturally own each other talk through this autoload
# instead of taking direct references. A producer emits on the bus; any
# number of listeners can connect. Adding a new cross-system signal is
# fine — just declare it here.
#
# Registered as an autoload (see project.godot [autoload] section) so it's
# globally accessible as `EventBus.<signal_name>`.
extends Node

# --- Resources -----------------------------------------------------------
signal wood_changed(new_amount: int)
