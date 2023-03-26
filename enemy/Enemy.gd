class_name Enemy extends CharacterBody2D

func _ready() -> void:
	$HurtBox.area_entered.connect(_on_hurtbox_area_entered)

func _on_hurtbox_area_entered(area):
	var projectile = area.get_parent()
	if projectile.is_in_group("projectiles"):
		projectile.queue_free()
		queue_free()
