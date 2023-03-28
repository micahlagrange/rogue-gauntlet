extends Camera2D


func _physics_process(_delta):
	return # ok testing
	position = position.lerp($"../Player".position,0.2)
