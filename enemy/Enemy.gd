class_name Enemy extends CharacterBody2D

var HEALTH = 1
var AGGRO_DISTANCE = 200.0

func _ready() -> void:
	$HurtBox.area_entered.connect(_on_hurtbox_area_entered)

func _on_hurtbox_area_entered(area):
	var projectile = area.get_parent()
	if projectile.is_in_group("projectiles"):
		projectile.queue_free()
		HEALTH -= 1
	
	if HEALTH <= 0:
		die()

func die():
	queue_free()
