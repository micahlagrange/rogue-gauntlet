extends Enemy

var target
var spawn_done = false
var SPEED = 20.0

@onready var spawn_position = global_position
@onready var initial_direction = Vector2(randi_range(-1,1), randi_range(-1,1)).normalized()
@onready var hunt_timer = $HuntTimer

func _ready() -> void:
	hunt_timer.timeout.connect(_search_for_target)
	super._ready()

func _physics_process(_delta: float) -> void:
	if target && global_position.distance_to(target.global_transform.origin) < AGGRO_DISTANCE:
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * SPEED
		move_and_slide()

func _search_for_target():
	var players = get_tree().get_nodes_in_group("players")
	var closest = null
	
	for p in players:
		var pos = p.position
		if not closest:
			closest = p
			continue

		if position.distance_to(pos) < position.distance_to(closest.position):
			closest = p
			
	target = closest
