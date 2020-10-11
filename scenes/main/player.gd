extends Node2D

func _physics_process(delta: float) -> void:
	$"/root/Server".update_position(int(name), position)
