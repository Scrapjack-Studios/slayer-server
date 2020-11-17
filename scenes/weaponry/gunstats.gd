extends Node2D

var Bullet = load("res://scenes/weaponry/bullet.tscn")

# TODO: these need to be rset for now
var shotgun_pellets
var shotgun_spread
var dmg
var bullet_lifetime
var bullet_size
var bullet_speed

# should this be a synced function?
remote func spawn_projectile(type, pos, rot):
	match type:
		"shotgun":
			for shotgun_pellet in shotgun_pellets:
				shotgun_spread =+ 0.5
				var pellet = Bullet.instance()
				pellet.start_at(pos, rot + rand_range(-0.04,0.04),'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
				$Bullets.add_child(pellet)
				if not is_network_master():
					pellet.set_collision_layer_bit(6, true)
		"burst_fire":
			var bullet = Bullet.instance()
			bullet.start_at(pos, rot,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
			$Bullets.add_child(bullet)
			if not is_network_master():
				bullet.set_collision_layer_bit(6, true)
		"auto":
			var bullet = Bullet.instance()
			bullet.start_at(pos, rot,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
			$Bullets.add_child(bullet)
			if not is_network_master():
				bullet.set_collision_layer_bit(6, true)
		"semi_auto":
			var bullet = Bullet.instance()
			bullet.start_at(pos, rot,'black', dmg, bullet_lifetime, bullet_size, bullet_speed)
			$Bullets.add_child(bullet)
			if not is_network_master():
				bullet.set_collision_layer_bit(6, true)
