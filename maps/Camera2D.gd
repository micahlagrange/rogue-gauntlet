extends Camera2D


func _physics_process(_delta):
	position = position.lerp($"../Player".position,0.2)
