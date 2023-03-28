class_name Projectile
extends Node2D

var SPEED = 100.0
var direction: Vector2

func _ready():
	set_as_top_level(true)
	$Area2D.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta):
	global_position += direction * SPEED * delta
	rotation_degrees += 20

func _on_area_2d_body_entered(_body: Node2D) -> void:
	queue_free()
