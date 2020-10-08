extends Node

var network = NetworkedMultiplayerENet.new()
var port = 4000
var max_players = 100

func _ready() -> void:
	start_server()

func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected", self, "on_peer_connected")
	network.connect("peer_disconnected", self, "on_peer_disconnected")

func on_peer_connected(player_id):
	print("User " + str(player_id) + " connected.")

func on_peer_disconnected(player_id):
	print("User " + str(player_id) + " disconnected.")