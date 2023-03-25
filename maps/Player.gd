extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -400.0

var projectile_scene: PackedScene = preload("res://projectile/base_projectile.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xdir = Input.get_action_strength("ui_right") - \
		Input.get_action_strength("ui_left")
	var ydir = Input.get_action_strength("ui_up") - \
		Input.get_action_strength("ui_down")
		
	var direction = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_accept"):
		spawn_projectile(direction)

	
	# direction
	if xdir != 0:
		direction.x = xdir
	if ydir != 0:
		direction.y = -ydir


	velocity = direction.normalized() * SPEED

	move_and_slide()

func spawn_projectile(direction):
	var projectile = projectile_scene.instantiate()
	projectile.global_position = self.global_position
	projectile.direction = direction
	add_child(projectile)
	
