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
	for player in GameController.get_node("Players"):
		kick_player(player, "Server Closed")
	emit_signal("server_stopped")
	get_tree().set_network_peer(null)

func kick_player(player, reason):
	rpc_id(player, "kicked", reason)
	get_tree().network_peer.disconnect_peer(player)

func on_player_connected(id): 
	print("Player " +  str(id) + " connected")
	$PlayerProcessing.add_player(id)
	rpc_id(id, "get_game_info", DEFAULT_MAP)

func on_player_disconnected(id):
	print("Player " + str(id) + " disconnected")
	if GameController.get_node("Players").has_node(str(id)):
		player_state_collection.erase(id)
		$PlayerProcessing.prune_player(id)
		rpc("despawn_player", id)

func send_world_state(world_state):
	rpc_unreliable("get_world_state", world_state)

remote func get_player_state(player_state):
	var id = get_tree().get_rpc_sender_id()
	if player_state_collection.has(id):
		if player_state_collection[id]["T"] < player_state["T"]: # check if player state is up-to-date
			player_state_collection[id] = player_state
	else:
		player_state_collection[id] = player_state

# gets called by player after they received the game info
remote func received_game_info():
	var id = get_tree().get_rpc_sender_id()
	rpc("spawn_player", id, start_position)

remote func fetch_server_time(client_time):
	var requester_id = get_tree().get_rpc_sender_id()
	rpc_id(requester_id, "return_server_time", OS.get_system_time_msecs(), client_time)

remote func fetch_latency(client_time):
	var requester_id = get_tree().get_rpc_sender_id()
	rpc_id(requester_id, "return_latency", client_time)
