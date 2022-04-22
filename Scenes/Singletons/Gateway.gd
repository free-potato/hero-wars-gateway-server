extends Node

const SERVER_PORT = 1910
const MAX_PLAYERS = 1000

var network = NetworkedMultiplayerENet.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	start_server()
	
func _process(delta):
	# if get_custom_multiplayer() == null:
	#    return
	if not custom_multiplayer.has_network_peer():
		return
	custom_multiplayer.poll()

func start_server():
	var gateway_api = MultiplayerAPI.new()
	network.create_server(SERVER_PORT, MAX_PLAYERS)
	set_custom_multiplayer(gateway_api)
	custom_multiplayer.set_root_node(self)
	custom_multiplayer.set_network_peer(network)
	
	print("Gateway Server Started")
	
	network.connect("peer_connected", self, "_peer_connected")
	network.connect("peer_disconnected", self, "_peer_disconnected")
	

func _peer_connected(peer_id):
	print("peer connected: " + str(peer_id))

func _peer_disconnected(peer_id):
	print("peed disconnected: " + str(peer_id))
	
# Login
remote func remote_request_login(username, password):
	var peer_id = custom_multiplayer.get_rpc_sender_id()
	AuthServer.authenticate_player(username, password, peer_id)
	
func send_login_request_result(result, peer_id):
	rpc_id(peer_id, "remote_login_request_result", result)
	network.disconnect_peer(peer_id)

# Create an account
remote func remote_new_account_request(username, password):
	var peer_id = custom_multiplayer.get_rpc_sender_id()
	AuthServer.create_account(username, password, peer_id)
	
func send_new_account_request_result(result, peer_id):
	rpc_id(peer_id, "remote_new_account_request_result", result)
	network.disconnect_peer(peer_id)
