extends CharacterBody3D
class_name Beast

var move_speed : float
var MOVE_SPEED = 1
var CHASE_SPEED = MOVE_SPEED * 1.5

@export var animation : AnimationTree
@export var nav : NavigationAgent3D
@export var rotation_speed : float = 0.25
@export var detection : Detection


var damage : float = 30
var stateMachine : StateMachine
var player : Player
var canMove = true
var seeingPlayer = false


func _enter_tree():
	add_to_group("Beast")
	stateMachine = $StateMachine

func _ready():
	player = Global._get_player()
	move_speed = MOVE_SPEED
	nav.connect("velocity_computed", velocity_computed)


func _process(delta: float) -> void:
	if nav.velocity.length() > 0:
		animation.set("parameters/conditions/isWalk", true)
		animation.set("parameters/conditions/isIdle", false)
	else:
		animation.set("parameters/conditions/isWalk", false)
		animation.set("parameters/conditions/isIdle", true)
		
	if not seeingPlayer:
		if velocity.length() > 0:
			var lookdir = atan2(-velocity.x, -velocity.z)
			rotation.y =  lerp_angle(rotation.y, lookdir, rotation_speed * delta)
	else:
		var playerloc = player.global_position - global_position
		var lookdir = atan2(-playerloc.x, -playerloc.z)
		rotation.y =  lerp_angle(rotation.y, lookdir, 0.25)

func _physics_process(delta):
	if not Global.incutscene and canMove:
		await get_tree().process_frame
		var next_location = nav.get_next_path_position()
		var currentLocation = global_transform.origin
		var new_velocity = (next_location - currentLocation).normalized() * move_speed

		nav.set_velocity(new_velocity)




func velocity_computed(safe_velocity):
	if(self.process_mode != PROCESS_MODE_DISABLED):
		if canMove:
			velocity = safe_velocity
			move_and_slide()
