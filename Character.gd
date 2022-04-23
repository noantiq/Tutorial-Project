extends KinematicBody2D

var velocity = Vector2.ZERO
const MOVEMENT_SPEED = 200
const GRAVITY = 30
const JUMP_FORCE = - 900
var jump_counter = 0
var max_jumps = 2

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = MOVEMENT_SPEED
	if Input.is_action_pressed("left"):
		velocity.x = - MOVEMENT_SPEED
	
	if is_on_floor():
		jump_counter = 0
	
	if Input.is_action_just_pressed("jump") and ((jump_counter < max_jumps) or is_on_floor()):
		velocity.y = JUMP_FORCE
		jump_counter += 1
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	velocity.y = velocity.y + GRAVITY
	velocity.x = lerp(velocity.x, 0, 0.20)
