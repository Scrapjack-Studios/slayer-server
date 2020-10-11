extends Node

func add_player(id):
	var player = load("res://scenes/main/player.tscn").instance()
	player.name = str(id)
	GameController.add_child(player)
