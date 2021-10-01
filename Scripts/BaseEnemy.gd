extends "res://Scripts/PlayerDetection.gd"

#onready state params
onready var navigation: Navigation2D = get_tree().get_root().find_node("Navigation2D", true, false)
onready var distToPlayer = global_position.distance_to(Player.global_position)
onready var wanderController = $WanderController
onready var attackController = $AttackController
onready var debugLabel = $Label #for Debug purposes REMOVE ON FINAL BUILD
onready var timer = $Timer

#enum of finite state machine
enum States {
	IDLE,
	WANDER,
	CHASE,
	SEARCH
}

#state params
var path: Array = []
var velocity: Vector2 = Vector2.ZERO
var isSearching: bool = false
var currentState = States.WANDER

#exported params 
export var acceptableRadius = 200
export var movementScale = 0.5 #for difficulty purposes the min being 0.1 and max being 1.0

func _physics_process(delta):
	match currentState:
		States.IDLE:
			debugLabel.text = "IDLE"
			velocity = velocity.move_toward(Vector2.ZERO, DEACCEL * delta)
			GetHasSeenPlayer()
			
		States.WANDER:
			GetHasSeenPlayer()
			Wander()
			
		States.CHASE:
			ChasePlayer()
			
		States.SEARCH:
			SearchPlayer()
			GetHasSeenPlayer()
	Move()

func Move():
	move_and_slide(velocity)
	
func GeneratePath(var FinalPos:Vector2):
	if navigation != null and Player!= null:
		path = navigation.get_simple_path(global_position, FinalPos, false)

func Navigate():
	if path.size() > 0 :
		velocity = global_position.direction_to(path[1]) * MAXSPEED * movementScale
		
		if global_position == path[0]:
			path.pop_front()

func GetHasSeenPlayer():
	if hasSeenPlayer:
		currentState = States.CHASE
	
func _on_Timer_timeout():
	currentState = States.WANDER

func Wander():
	if not isSearching:
		debugLabel.text = "WANDER"
		GeneratePath(wanderController.targetPos)
		Navigate()
		if wanderController.targetPos == path[0]:
			velocity = velocity.move_toward(Vector2.ZERO, DEACCEL)

func ChasePlayer():
	distToPlayer = global_position.distance_to(Player.global_position)
	
	if hasSeenPlayer:
		debugLabel.text = "CHASE"
		GeneratePath(Player.global_position)
		Navigate()
		if distToPlayer <= acceptableRadius:
			attackController.AttackPlayer()
		else:
			currentState = States.CHASE
	else:
		currentState = States.SEARCH

func SearchPlayer():
	debugLabel.text = "SEARCH"
	isSearching = true
	GeneratePath(lastSeenPlayerPos)
	Navigate()
	InvestigateLastPos()
	
func InvestigateLastPos():
	if lastSeenPlayerPos == path[0] and timer.is_stopped():
		reachedLastPos = true
		isSearching = false
		currentState = States.IDLE
		timer.start()
