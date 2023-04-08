extends Camera2D

var player

func _physics_process(_delta):
	position = position.lerp(player.position,0.2)
