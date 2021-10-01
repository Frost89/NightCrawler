extends Node2D

export var wRange = 100

onready var startPos = global_position
onready var targetPos = global_position
onready var timer = $Timer

func UpdateTargetPos():
	var targetVector = Vector2(rand_range(-wRange,wRange), rand_range(-wRange,wRange))
	targetPos = startPos + targetVector
	
func _on_Timer_timeout():
	UpdateTargetPos()
	timer.start(rand_range(1,5))
