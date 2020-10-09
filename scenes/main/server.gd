extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_MAP = "ShootingRange"
const DEFAULT_PORT = 4000
const MAX_PLAYERS = 100

var network = NetworkedMultiplayerENet.new()
var players = { }
var start_position = Vector2(360,180)
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
	get_tree().connect('network_peer_connected', self, 'on_player_connected')
	get_tree().connect('network_peer_disconnected', self, 'on_player_disconnected')
	create_server(DEFAULT_PORT)

func create_server(port):
	network.create_server(port, MAX_PLAYERS)
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

func on_player_connected(connected_player_id): 
	connected_player = connected_player_id
	var local_player_id = get_tree().get_network_unique_id()
	rpc_id(1, '_request_player_info', local_player_id, connected_player_id)
	rpc_id(1, '_request_map', local_player_id)

func on_player_disconnected(id):
	disconnected_player_info = players[id]
	players.erase(id)
	  
#remote func _request_player_info(request_from_id, player_id):
#	if get_tree().is_network_server():
#		rpc_id(request_from_id, '_send_player_info', player_id, players[player_id])
#
#remote func _send_player_info(id, info):
#	players[id] = info
#	if connected_player in players:
#		connected_player_info = players[connected_player]
#		emit_signal("player_connection_completed")
#
#remote func _request_players(request_from_id):
#	if get_tree().is_network_server():
#		rpc_id(request_from_id, '_send_players', players)
#
#remote func _send_players(players_array):
#	players = players_array
#
#remote func _request_map(request_from_id):
#	if get_tree().is_network_server():
#		rpc_id(request_from_id, '_send_map', Global.map)
#
#remote func _send_map(map):
#	Global.map = map
#	get_tree().change_scene("res://GameController.tscn")
