extends "res://Scripts/TemplateCharacter.gd"

#config params
const RED = Color(1.0, 0.25, 0.25) #for debug purposes
const WHITE = Color(1.0, 1.0, 1.0) #for debug purposes

#state variables
onready var los = $LineOfSightRaycast
var Player
var hasSeenPlayer
var lastSeenPlayerPos: Vector2
var reachedLastPos: bool = true

func _ready():
	Player = get_tree().get_root().find_node("Player", true, false) #finds the player in the current scene
	
func FindPlayer():
	if Player:
		los.look_at(Player.global_position)
		hasSeenPlayer = CheckPlayerInLOS()
		if hasSeenPlayer:
			$AnimatedSprite.modulate = RED
		else:
			$AnimatedSprite.modulate = WHITE

func CheckPlayerInLOS():
	if los.get_collider() == Player:
		lastSeenPlayerPos = Player.global_position
		reachedLastPos = false
		return true
	reachedLastPos = true
	return false

func _physics_process(delta):
	FindPlayer()
