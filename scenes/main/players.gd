extends Node

func add_player(id):
	var player = load("res://scenes/main/player.tscn").instance()
	player.name = str(id)
	player.set_network_master(id)
	GameController.add_child(player)
	
func prune_player(id):
	get_node("/root/Server").players.erase(id)
