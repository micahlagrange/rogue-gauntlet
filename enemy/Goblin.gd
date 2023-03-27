extends Enemy

var target

var SPEED = 20.0

func _physics_process(_delta: float) -> void:
	if target && global_position.distance_to(target.global_transform.origin) < AGGRO_DISTANCE:
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * SPEED
		# Move towards the target marker
		move_and_slide()
