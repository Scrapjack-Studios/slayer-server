extends Node

const DEFAULT_PORT = 4000
const DEFAULT_MAX_PLAYERS = 100
const DEFAULT_MAP = "ShootingRange"

var network = NetworkedMultiplayerENet.new()
var players = {}
var start_position = Vector2(360,180)

signal server_stopped

func _ready() -> void:
	get_tree().connect('network_peer_connected', self, 'on_player_connected')
	get_tree().connect('network_peer_disconnected', self, 'on_player_disconnected')
	create_server(DEFAULT_PORT, DEFAULT_MAX_PLAYERS)

func create_server(port, max_players):
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)

func close_server():
	for player in players:
		kick_player(player, "Server Closed")
	emit_signal("server_stopped")
	get_tree().set_network_peer(null)

func kick_player(player, reason):
	rpc_id(player, "kicked", reason)
	get_tree().network_peer.disconnect_peer(player)

func update_position(id, position):
	players[id].position = position

func on_player_connected(id): 
	print(str(id) + " connected.")
	rpc_id(id, "fetch_player_info")
	rpc_id(id, "get_map", DEFAULT_MAP)
	rpc_id(id, "get_start_position", start_position)

func on_player_disconnected(id):
	print(str(id) + " disconnected.")
	$Players.prune_player(id)

# gets called by the player when they connect
remote func get_player_info(id, info):
	players[id] = info # add to players dict
	$Players.add_player(id)
	rpc("get_players_list", players) # updates everyone's player list
	get_node("/root/GameController").rpc_id(id, "spawn", id, info)
	print(players)
