extends Node2D

onready var parent = get_owner()

func AttackPlayer():  	#rn all it is doing is debugging if attack works or not 
						#NEED ANIMS, HURTBOXES and HITBOXES to implement attacking 
	if parent.debugLabel:
		parent.debugLabel.text = "MELEE"
		parent.velocity = parent.velocity.move_toward(Vector2.ZERO, parent.DEACCEL)
	else:
		print ("Cant find any debugLabel on Node or Parent not present")
