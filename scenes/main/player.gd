extends Node2D

remote var puppet_position
remote var puppet_movement
remote var puppet_mouse_position
remote var puppet_muzzle_position
remote var puppet_weapon_position
remote var puppet_weapon_flip

func _physics_process(delta: float) -> void:
	$"/root/Server".update_position(int(name), position)
