extends KinematicBody2D

var velocity = Vector2(0, 0)
var movement_speed = 200

func _physics_process(delta):
	if Input.is_action_pressed("right"):
		velocity.x = movement_speed
	if Input.is_action_pressed("left"):
		velocity.x = - movement_speed
	
	move_and_slide(velocity, Vector2.UP)
	
	velocity.x = lerp(velocity.x, 0, 0.15)
