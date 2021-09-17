extends KinematicBody2D

#MOVEMENT
var Acceleration = 400
var Deceleration = 800
var MaxSpeed = 200
var DashSpeed = 600
var DashDuration = 0.2
var CanDash = 100 #no-dash-spam
var Velocity = Vector2.ZERO

#COMBAT
var Health = 100

onready var Dash = $Dash
onready var animationPlayer = $MainChar/AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	move(delta)
	move_and_slide(Velocity)

func move(delta):
	
	var InputVector = Vector2.ZERO
	
	InputVector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	InputVector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	InputVector = InputVector.normalized()
	
	if InputVector != Vector2.ZERO:
		
		#DASH
		if Input.is_action_just_pressed("Dash") && !Dash.IsDashing() && CanDash == 100:
			CanDash = 0
			Dash.StartDash(DashDuration)
		
		if Dash.IsDashing():
			MaxSpeed = 2000
			Acceleration = 10000
			Deceleration = 10000
						   
		animationTree.set("parameters/Idle/blend_position", InputVector)
		animationTree.set("parameters/Walk/blend_position", InputVector)
		animationState.travel("Walk")
		Velocity += InputVector * Acceleration * delta
		Velocity = Velocity.clamped(MaxSpeed)
	
	else:
		
		animationState.travel("Idle")
		Velocity = Velocity.move_toward(Vector2.ZERO, Deceleration * delta)
		Velocity = Velocity.clamped(MaxSpeed)
	
	#default
	MaxSpeed = 200
	Acceleration = 400
	Deceleration = 800
	
	#patchwork dash-stamina
	if CanDash < 100:
		CanDash += 1
		if CanDash == 100:
			print("DASH READY")
