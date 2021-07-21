extends KinematicBody2D

var velocity = Vector2()
const SPEED = 200

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)

func get_input():
	velocity = Vector2()
	
	var up = Input.is_action_pressed("Up")
	var down = Input.is_action_pressed("Down")
	var left = Input.is_action_pressed("Left")
	var right = Input.is_action_pressed("Right")
	
	if up:
		velocity.y -= 1
	if down:
		velocity.y += 1
	if left:
		velocity.x -= 1
	if right:
		velocity.x += 1
	velocity = velocity.normalized() * SPEED 
