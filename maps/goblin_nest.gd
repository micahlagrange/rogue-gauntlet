extends Enemy

var goblin_scene = preload("res://enemy/goblin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	HEALTH = 4
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	super._ready()
	
func _on_spawn_timer_timeout() -> void:
	spawn_goblin()

func spawn_goblin():
	if num_gerblins() > 10:
		return
	
	var goblin = goblin_scene.instantiate()
	goblin.add_to_group("enemies")
	goblin.target = get_parent().get_node("Player")
	add_child(goblin)
	

func num_gerblins():
	return len(get_children()) - 3

func die():
	for child in get_children().filter(func(i): return i.is_in_group("enemies")):
		child.reparent(get_parent())
		super.die()
