extends Node2D

# TODO: rset these
var velocity = Vector2()
export (int) var speed
export (int, 0, 200) var push = 100
var damage
var hit_pos
var weapon_type

func start_at(pos, dir, type, dmg, _lifetime, size, spd):
	position = pos
	rotation = dir
#	$Sprite.set_scale(size)
	damage = dmg
	velocity = Vector2(speed, 0).rotated(dir)
#	add_to_group("bullets")
	speed = spd