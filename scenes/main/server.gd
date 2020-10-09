extends Node

var network = NetworkedMultiplayerENet.new()
var port = 4000
var max_players = 100

var players = { }
var start_position = Vector2(360,180)
var self_data = {name = '', position = Vector2(), received_disconnect=false}
var disconnected_player_info
var connected_player_info
var connected_player
var disconnected

signal player_disconnected
signal server_disconnected
signal player_connection_completed
signal player_disconnection_completed
signal server_stopped

func _ready() -> void:
	start_server()

func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Server started")
	
	network.connect("peer_connected", self, "on_peer_connected")
	network.connect("peer_disconnected", self, "on_peer_disconnected")

func close_server():
	for player in players:
		kick_player(player, "Server Closed")
	emit_signal("server_stopped")
	get_tree().set_network_peer(null)

func kick_player(player, reason):
	rpc_id(player, "kicked", reason)
	get_tree().network_peer.disconnect_peer(player)

func on_peer_connected(player_id):
	print("User " + str(player_id) + " connected.")

func on_peer_disconnected(player_id):
	print("User " + str(player_id) + " disconnected.")
