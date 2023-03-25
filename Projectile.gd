class_name Projectile
extends Node2D

var SPEED = 200.0
var direction: Vector2

func _ready():
	set_as_top_level(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += direction * SPEED * delta
