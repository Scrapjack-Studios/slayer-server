extends Node2D

# TODO: rset these
var velocity = Vector2()
export (int) var speed
export (int, 0, 200) var push = 100
var damage
var hit_pos
var weapon_type

remote func spawn_projectile(pos, dir, type, dmg, _lifetime, size, spd):
	print("Projectile spawned!")
	position = pos
	rotation = dir
#	$Sprite.set_scale(size)
	damage = dmg
	velocity = Vector2(speed, 0).rotated(dir)
#	add_to_group("bullets")
	speed = spd
