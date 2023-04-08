extends Enemy


var target_vector: Vector2
var spawn_done = false
var SPEED = 20.0
var attack: bool


@onready var spawn_position = global_position
@onready var hunt_timer = $HuntTimer
@onready var nn_requester = HTTPRequest.new()
@onready var nn_call_timer = $NetCallTimer


func _ready() -> void:
	#hunt_timer.timeout.connect(_search_for_target)
	add_child(nn_requester)
	nn_requester.request_completed.connect(self._nn_requester_completed)
	schedule_nn()
	super._ready()



func _physics_process(_delta: float) -> void:
	if target_vector: # && global_position.distance_to(target_vector) < AGGRO_DISTANCE:
		var direction = (target_vector - global_transform.origin).normalized()
		velocity = direction * SPEED
		move_and_slide()
	
	if attack:
		play_attack_anim()
		attack = false


# not used rn
func _search_for_target():
	var players = get_tree().get_nodes_in_group("players")
	var closest = null
	for p in players:
		print(p)
		var pos = p.position
		if not closest:
			closest = p
			continue
		if position.distance_to(pos) < position.distance_to(closest.position):
			closest = p
	# update target
	target_vector = closest.global_transform.origin



# initiate request to the neural net to update the actions
func call_nn():
	var error = nn_requester.request("http://127.0.0.1:5000/")
	if error != OK:
		push_error("An error occurred in the HTTP request.")



# do a flip
func play_attack_anim():
	pass



# Called when the neural net request is completed
func _nn_requester_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	# populate actions
	target_vector.x = response["target"][0]
	target_vector.y = response["target"][1]
	attack = response["attack"] == true
	

	# call it again for the next update
	schedule_nn()




func schedule_nn():
	nn_call_timer.start()

func _on_net_call_timer_timeout() -> void:
	call_nn()
