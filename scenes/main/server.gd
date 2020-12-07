extends Node

const DEFAULT_PORT = 4000
const DEFAULT_MAX_PLAYERS = 100
const DEFAULT_MAP = "ShootingRange"

var network = NetworkedMultiplayerENet.new()
var player_state_collection = {}
var start_position = Vector2(448,863)

func _ready() -> void:
	get_tree().connect('network_peer_connected', self, 'on_player_connected')
	get_tree().connect('network_peer_disconnected', self, 'on_player_disconnected')
	create_server(DEFAULT_PORT, DEFAULT_MAX_PLAYERS)

func create_server(port, max_players):
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)

func close_server():
#	for player in players:
#		kick_player(player, "Server Closed")
	emit_signal("server_stopped")
	get_tree().set_network_peer(null)

func kick_player(player, reason):
	rpc_id(player, "kicked", reason)
	get_tree().network_peer.disconnect_peer(player)

func on_player_connected(id): 
	print(str(id) + " connected.")
	rpc_id(id, "fetch_player_info")
	rpc_id(id, "get_map", DEFAULT_MAP)

func on_player_disconnected(id):
	print(str(id) + " disconnected.")
	$Players.prune_player(id)
	rpc("despawn_player", id)

remote func get_player_state(player_id, player_state):
	if player_state_collection.has(player_id):
		if player_state_collection[player_id]["T"] < player_state["T"]:
			player_state_collection[player_id] = player_state

# gets called by the player when they connect
remote func get_player_info(id):
	$Players.add_player(id)
	rpc("spawn_player", id, start_position)
