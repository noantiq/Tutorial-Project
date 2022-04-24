extends KinematicBody2D

var velocity = Vector2.ZERO
const GRAVITY = 20
var movement_speed = 50
enum DIRECTION {RIGHT = 1, LEFT = - 1}
export var direction = DIRECTION.LEFT
export var can_detect_cliffs = true

func _ready():
	set_direction()
	$floor_detection.enabled = can_detect_cliffs
	if can_detect_cliffs:
		set_modulate(Color(1.2, 0.5, 1))

func set_direction():
	$floor_detection.position.x = $CollisionShape2D.shape.get_extents().x * direction
	if direction == DIRECTION.RIGHT:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func _physics_process(delta):
	if is_on_wall() or can_detect_cliffs and not $floor_detection.is_colliding() and is_on_floor():
		direction = direction * - 1
		set_direction()
	
	velocity.y += GRAVITY
	
	velocity.x = int(direction) * movement_speed
	
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_top_detection_body_entered(body):
	$Timer.start()
	$Sprite.play("squashed")
	$SquashSound.play()
	movement_speed = 0
	set_collision_layer_bit(4, 0)
	set_collision_mask_bit(0, 0)
	$top_detection.set_collision_layer_bit(4, 0)
	$top_detection.set_collision_mask_bit(0, 0)
	$outer_detection.set_collision_layer_bit(4, 0)
	$outer_detection.set_collision_mask_bit(0, 0)
	body.bounce()


func _on_outer_detection_body_entered(body):
	body.get_hit(position.x)



func _on_Timer_timeout():
	queue_free()
