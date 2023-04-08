extends Node2D

@onready var main_menu = $CanvasLayer/MainMenu
@onready var address_entry = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/JoinBox/AddressEntry

@onready var hud = $CanvasLayer/HUD
@onready var health_bar = $CanvasLayer/HUD/HealthBar
@onready var error_message = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/ErrorBox
@onready var spawn_point_list = $Spawns
@onready var player_camera = preload("res://player/player_camera.tscn")

const Player = preload("res://player/player.tscn")
const PORT = 9001

func _ready() -> void:
	$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/HostButton.pressed.connect(_on_host_button_pressed)
	$CanvasLayer.show()
	Events.respawn_player.connect(_on_player_respawned)

func _on_host_button_pressed() -> void:
	main_menu.hide()
	hud.show()
	spawn_player()

func _on_player_respawned(player):
	player.position = get_spawn_point().position

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()
		
func get_spawn_point():
	return spawn_point_list.get_children().pick_random()

func spawn_player():
	var player = Player.instantiate()
	player.add_to_group("players")
	player.position = get_spawn_point().position
	add_child(player)

func spawn_player_camera(player):
	var cam = player_camera.instantiate()
	cam.player = player
	add_child(cam)
	print(player.name, " set_camera ", cam)
	player.set_camera(cam)
	
func update_health_bar(health_value):
	health_bar.value = health_value

func try_or_error(success: bool, message):
	if !success:
		error_message.text = message
		hud.hide()
		main_menu.show()
		error_message.show()

	return success
