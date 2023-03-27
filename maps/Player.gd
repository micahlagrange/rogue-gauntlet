extends CharacterBody2D


const SPEED = 60.0
const JUMP_VELOCITY = -400.0

var facing = Vector2.DOWN
var projectile_scene: PackedScene = preload("res://projectile/base_projectile.tscn")
var can_shoot: bool

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	can_shoot = true
	$ShootTimer.timeout.connect(_shoot_cooldown)
	
func _shoot_cooldown():
	can_shoot = true

func _physics_process(_delta):
	var direction = Vector2.ZERO
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var xdir = Input.get_action_strength("right") - \
		Input.get_action_strength("left")
	var ydir = Input.get_action_strength("up") - \
		Input.get_action_strength("down")
		
	# direction
	if xdir != 0:
		direction.x = xdir
	if ydir != 0:
		direction.y = -ydir

	if direction != Vector2.ZERO:
		facing = direction.normalized()
		
	if Input.is_action_pressed("shoot") && can_shoot:
		spawn_projectile(facing)
		can_shoot = false

	velocity = direction.normalized() * SPEED
	move_and_slide()

func spawn_projectile(direction):
	var projectile = projectile_scene.instantiate()
	projectile.add_to_group("projectiles")
	projectile.global_position = self.global_position
	projectile.direction = direction
	add_child(projectile)

