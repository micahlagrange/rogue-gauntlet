extends Enemy

var target

var SPEED = 60.0

func _physics_process(delta: float) -> void:
	if target:	
		var direction = (target.global_transform.origin - global_transform.origin).normalized()
		velocity = direction * SPEED
		# Move towards the target marker
		move_and_slide()
