extends Node

var world_state

func _physics_process(delta: float) -> void:
	if not get_parent().player_state_collection.empty():
		world_state = get_parent().player_state_collection.duplicate(true) # makes a deep copy of player states
		for player in world_state.keys():
			world_state[player].erase("T") # timestamp isn't needed for this
		world_state["T"] = OS.get_system_time_msecs()
		# Verification
		# Anti-cheat
		# Physics checks
		# Etc.
		get_parent().send_world_state(world_state)
