extends KinematicBody2D

var velocity = Vector2.ZERO
const GRAVITY = 20
var movement_speed = 50
enum DIRECTION {right = 1, left = - 1}
export var facing_direction = DIRECTION.left
export var can_detect_cliffs = true

func _ready():
	set_direction()
	$floor_detection.enabled = can_detect_cliffs

func set_direction():
	$floor_detection.position.x = $CollisionShape2D.shape.get_extents().x * facing_direction
	if facing_direction == DIRECTION.right:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

func _physics_process(delta):
	if is_on_wall() or can_detect_cliffs and not $floor_detection.is_colliding() and is_on_floor():
		facing_direction = facing_direction * - 1
		set_direction()
	
	velocity.y += GRAVITY
	
	velocity.x = int(facing_direction) * movement_speed
	
	velocity = move_and_slide(velocity, Vector2.UP)
