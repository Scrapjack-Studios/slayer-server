extends Node2D

var Bullet = load("res://src/weaponry/bullet.tscn")

# TODO: these need to be rset for now
puppet var puppet_dmg
puppet var puppet_bullet_lifetime
puppet var puppet_bullet_size
puppet var puppet_bullet_speed
puppet var puppet_shotgun_pellets
puppet var puppet_shotgun_spread
puppet var puppet_burst_ammount

remote func fire(type, pos, rot):
	match type:
		"shotgun":
			for puppet_shotgun_pellet in puppet_shotgun_pellets:
				puppet_shotgun_spread =+ 0.5
				var pellet = Bullet.instance()
				pellet.spawn_projectile(
					pos, 
					rot + rand_range(-0.04,0.04),
					"black",
					puppet_dmg,
					puppet_bullet_lifetime, 
					puppet_bullet_size, 
					puppet_bullet_speed
				)
				$Bullets.add_child(pellet)
		"burst_fire":
			for b in puppet_burst_ammount: 
				var bullet = Bullet.instance()
				bullet.spawn_projectile(
					pos, 
					rot,
					"black",
					puppet_dmg, 
					puppet_bullet_lifetime, 
					puppet_bullet_size, 
					puppet_bullet_speed
				)
				$Bullets.add_child(bullet)
		"automatic":
			var bullet = Bullet.instance()
			bullet.spawn_projectile(
				pos, 
				rot,
				"black",
				puppet_dmg, 
				puppet_bullet_lifetime, 
				puppet_bullet_size, 
				puppet_bullet_speed
			)
			$Bullets.add_child(bullet)
		"semi_auto":
			var bullet = Bullet.instance()
			bullet.spawn_projectile(
				pos,
				rot,
				"black",
				puppet_dmg,
				puppet_bullet_lifetime,
				puppet_bullet_size,
				puppet_bullet_speed
			)
			$Bullets.add_child(bullet)
