class_name CooldownBuff extends Area2D

@export var amount: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_area_2d_body_entered)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		body.pickup(self)
		queue_free()
