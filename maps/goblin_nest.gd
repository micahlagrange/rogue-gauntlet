extends Enemy


var goblin_scene = preload("res://enemy/goblin.tscn")
var rand = RandomNumberGenerator.new()
var min_dist = 10
var spawn_area_half = 30

@onready var top_left_corner = $SpawnableArea/TLCorner
@onready var top_right_corner = $SpawnableArea/TRCorner
@onready var bottom_left_corner = $SpawnableArea/BLCorner
@onready var bottom_right_corner = $SpawnableArea/BRCorner
@onready var spawn_timer = $SpawnTimer
@onready var texture_sprite = $Sprite2D


func _ready() -> void:
	HEALTH = 4
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	super._ready()


func _on_spawn_timer_timeout() -> void:
	spawn_goblin()


func spawn_goblin():
	if dead:
		return
		
	if len(get_all_gerblins()) >= 9:
		return

	rand.randomize()

	var nextLoc = get_next_spawn_loc()
	var goblin = goblin_scene.instantiate()
	
	goblin.add_to_group("enemies")
	goblin.position = nextLoc

	add_child(goblin)


func get_all_gerblins():
	return get_children().filter(func(i): return i.is_in_group("enemies"))


func die():
	dead = true
	collision_layer = 0
	collision_mask = 0
	texture_sprite.hide()


func _physics_process(_delta: float) -> void:
	if dead:
		var children = get_all_gerblins()
		if len(children) <= 0:
			super.die()


func get_next_spawn_loc():
	while true:
		var x = rand.randf_range(top_left_corner.position.x, bottom_right_corner.position.x)
		var y = rand.randf_range(top_right_corner.position.y, bottom_left_corner.position.y)

		var newLoc = Vector2(x,y)
		var tooClose = false

		for loc in spawn_locations():
			if newLoc.distance_to(loc) < min_dist:
				tooClose = true
				break

		if !tooClose:
			return newLoc


func spawn_locations():
	return get_all_gerblins().map(func(i): return i.position)

