extends Node2D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/JoinBox/AddressEntry

@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar
@onready var error_message = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ErrorBox
@onready var spawn_point_list = $Spawns

const Player = preload("res://player/player.tscn")
const PORT = 9001
var enet_peer = ENetMultiplayerPeer.new()

func _ready() -> void:
	$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HostButton.pressed.connect(_on_host_button_pressed)
	$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/JoinBox/JoinButton.pressed.connect(_on_join_button_pressed)
	
	Events.respawn_player.connect(_on_player_respawned)

func _on_host_button_pressed() -> void:
	main_menu.hide()
	hud.show()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(spawn_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	spawn_player(multiplayer.get_unique_id())

	upnp_setup()
	
	print("host success")

func _on_join_button_pressed() -> void:
	main_menu.hide()
	hud.show()
	error_message.hide()
	var enet_result = enet_peer.create_client(address_entry.text, PORT)
	if not try_or_error(enet_result == 0, "[Enet Peer ERR] could not connect to multiplayer server %s:%s, got %s" % [address_entry.text, PORT, enet_result]):
		enet_peer = ENetMultiplayerPeer.new()
		return
	
	multiplayer.multiplayer_peer = enet_peer

func _on_player_respawned(player):
	player.position = get_spawn_point().position

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
		
func get_spawn_point():
	return spawn_point_list.get_children().pick_random()

func spawn_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	player.position = get_spawn_point().position
	add_child(player)
	print("added ", player)
	if player.is_multiplayer_authority():
		print('conn')
		Events.health_changed.connect(update_health_bar)
		
func update_health_bar(health_value):
	health_bar.value = health_value

func _on_multiplayer_spawner_spawned(player: Node) -> void:
	if player.is_multiplayer_authority():
		Events.health_changed.connect(update_health_bar)
		player.position = get_spawn_point().position

func upnp_setup():
	var upnp = UPNP.new()
	
	var discover_result = upnp.discover()
	try_or_error(discover_result == UPNP.UPNP_RESULT_SUCCESS, "[UPnP ERR] Discover Failed, got %s" % discover_result)
	try_or_error(upnp.get_gateway() && upnp.get_gateway().is_valid_gateway(), "[UPnP ERR] Invalid gateway")
	var map_result = upnp.add_port_mapping(PORT)
	try_or_error(map_result == UPNP.UPNP_RESULT_SUCCESS, "[UPnP ERR] Port mapping failed, got %s" % map_result)
	print("UPnP Setup Success. Address: %s" % upnp.query_external_address())

func try_or_error(success: bool, message):
	if !success:
		error_message.text = message
		hud.hide()
		main_menu.show()
		error_message.show()

	return success
