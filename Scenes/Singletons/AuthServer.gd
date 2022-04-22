extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 1911


# Called when the node enters the scene tree for the first time.
func _ready():
	connect_to_server()


func connect_to_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_client(SERVER_IP, SERVER_PORT)
	get_tree().network_peer = peer
	
	peer.connect("connection_succeeded", self, "_on_connection_succeeded")
	peer.connect("connection_failed", self, "_on_connection_failed")
	

func _on_connection_succeeded():
	print("Connected to the auth server")
	
func _on_connection_failed():
	print("Connection to the auth server has failed")
	
func authenticate_player(username, password, peer_id):
	rpc_id(1, "remote_authenticate_player", username, password, peer_id)
	
remote func remote_authentication_result(result, peer_id):
	Gateway.send_login_request_result(result, peer_id)
	
func create_account(username, password, peer_id):
	rpc_id(1, "remote_create_account", username, password, peer_id)
	
remote func remote_create_account_result(result, peer_id):
	Gateway.send_new_account_request_result(result, peer_id)
	
