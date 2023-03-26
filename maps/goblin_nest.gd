extends Marker2D

var goblin_scene = preload("res://enemy/goblin.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)


func _on_spawn_timer_timeout() -> void:
	spawn_goblin()

func spawn_goblin():
	var goblin = goblin_scene.instantiate()
	goblin.global_position = self.global_position
	goblin.add_to_group("enemies")
	goblin.target = $"../../Player"
	get_parent().add_child(goblin)
