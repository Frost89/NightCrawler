extends KinematicBody2D

export var MAXSPEED = 80
export var friction = 300

var seenPlayer = null
var velocity = Vector2.ZERO

func _physics_process(delta):
	chase(delta)
	velocity = move_and_slide(velocity)

func _on_DetectionRadius_body_entered(body):
	seenPlayer = body

func _on_DetectionRadius_body_exited(body):
	seenPlayer = null

func chase(delta):
	if seenPlayer:
		velocity = position.direction_to(seenPlayer.position) * MAXSPEED
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
