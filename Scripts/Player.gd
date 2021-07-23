extends KinematicBody2D

const maxspeed = 300
const acceleration = 2400
const friction = 1200

var velocity = Vector2.ZERO

onready var animationPlayer = $MainChar/AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	move(delta)
	move_and_slide(velocity)

func move(delta):
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:               
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Walk/blend_position", input_vector)
		animationState.travel("Walk")
		velocity = velocity.move_toward(input_vector * maxspeed, acceleration * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
