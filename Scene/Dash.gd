extends Node2D

onready var DurationTimer = $DurationTimer

func StartDash(Duration):
	DurationTimer.wait_time = Duration
	DurationTimer.start()

func IsDashing():
	return !DurationTimer.is_stopped()
