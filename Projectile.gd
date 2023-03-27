class_name Projectile
extends Node2D

var SPEED = 200.0
var direction: Vector2

func _ready():
	set_as_top_level(true)
	$Area2D.body_entered.connect(_on_area_2d_body_entered)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += direction * SPEED * delta


func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
