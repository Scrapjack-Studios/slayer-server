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
	for player in $Players:
		kick_player(player, "Server Closed")
	emit_signal("server_stopped")
	get_tree().set_network_peer(null)

func kick_player(player, reason):
	rpc_id(player, "kicked", reason)
	get_tree().network_peer.disconnect_peer(player)

func on_player_connected(id): 
	print(str(id) + " connected.")
	$Players.add_player(id)
	rpc_id(id, "get_game_info", DEFAULT_MAP)

func on_player_disconnected(id):
	print(str(id) + " disconnected.")
	$Players.prune_player(id)
	rpc("despawn_player", id)

# gets called by the player after they received the game info
remote func received_game_info():
	var id = get_tree().get_rpc_sender_id()
	rpc("spawn_player", id, start_position)

remote func get_player_state(state):
	var id = get_tree().get_rpc_sender_id()
	if player_state_collection.has(id):
		if player_state_collection[id]["T"] < state["T"]: # check if the state is the latest
			player_state_collection[id] = state
	else:
		player_state_collection[id] = state
