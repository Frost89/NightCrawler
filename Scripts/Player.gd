extends KinematicBody2D

const maxspeed = 300
const acceleration = 2400
const friction = 1200

var velocity = Vector2.ZERO

func _physics_process(delta):
	
	var input_vector = Vector2.ZERO
	
	input_vector.x = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	input_vector.y = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		
		if input_vector.x >0:                            #animation code
			$MainChar.play("walk left")                  
			$MainChar.flip_h =true
		else:
			$MainChar.play("walk left")                  #animation code
			$MainChar.flip_h = false
			
		velocity = velocity.move_toward(input_vector * maxspeed, acceleration * delta)
		
		if input_vector.y !=0:
			$MainChar.play("front walk")                 
	
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		$MainChar.play("idle")
	
	move_and_slide(velocity)

