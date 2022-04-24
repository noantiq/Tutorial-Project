extends KinematicBody2D

enum States {AIR, FLOOR, LADDER, WALL}
var state = States.AIR
var velocity = Vector2.ZERO
const MOVEMENT_SPEED = 200
const RUN_SPEED_MODIFIER = 2
const GRAVITY = 30
const JUMP_FORCE = - 900
var jump_counter = 0
var max_jumps = 2

func _physics_process(delta):
	
	match state:
		States.AIR:
			if is_on_floor():
				state = States.FLOOR
				continue
			$Sprite.play("air")
			var speed_modifier
			if Input.is_action_pressed("left"):
				speed_modifier = - 1
				$Sprite.flip_h = true
			elif Input.is_action_pressed("right"):
				speed_modifier = 1
				$Sprite.flip_h = false
			else:
				speed_modifier = 0

			if Input.is_action_just_pressed("jump") and ((jump_counter < max_jumps)):
				velocity.y = JUMP_FORCE
				$JumpSound.play()
				jump_counter += 1
			move_and_fall(speed_modifier)
			
		States.FLOOR:
			if not is_on_floor():
				state = States.AIR
			jump_counter = 0
			var speed_modifier
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
				$Sprite.play("walking")
				$Sprite.set_speed_scale(1)
				speed_modifier = - 1 if Input.is_action_pressed("left") else 1
				$Sprite.flip_h = true if Input.is_action_pressed("left") else false
				
				if Input.is_action_pressed("run"):
					speed_modifier = speed_modifier * RUN_SPEED_MODIFIER
					$Sprite.set_speed_scale(2)
			else:
				$Sprite.play("idle")
				speed_modifier = 0
			
			if Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_FORCE
				$JumpSound.play()
				jump_counter += 1
				state = States.AIR
			move_and_fall(speed_modifier)
		States.LADDER:
			pass
		States.WALL:
			pass

func move_and_fall(speed_modifier):
	velocity.x = lerp(velocity.x, MOVEMENT_SPEED * speed_modifier, 0.1)
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y = velocity.y + GRAVITY

func _on_fallzone_body_entered(body):
	get_tree().change_scene("res://GameOver.tscn")

func bounce():
	velocity.y = JUMP_FORCE * 0.5

func get_hit(enemy_position):
	set_modulate(Color(1, 0.3, 0.3, 0.3))
	velocity.y = JUMP_FORCE * 0.3
	
	if position.x < enemy_position:
		velocity.x = JUMP_FORCE * 0.5
	else:
		velocity.x = JUMP_FORCE * - 0.5
	
	Input.action_release("left")
	Input.action_release("right")
	
	$DeathTimer.start()

func _on_DeathTimer_timeout():
	get_tree().change_scene("res://GameOver.tscn")
