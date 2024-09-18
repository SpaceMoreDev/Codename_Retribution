extends CharacterBody3D
class_name Beast

var MOVE_SPEED : float = 1.2
var CHASE_SPEED = MOVE_SPEED * 1.5
var ROTATION_SPEED : float = 2.25


@export var animation : AnimationTree
@export var nav : NavigationAgent3D
@export var detection : Detection
@export var Head_IK : SkeletonIK3D
@export var target : Node3D
@export var head : Node3D

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
	Head_IK.start()
	nav.connect("velocity_computed", velocity_computed)


func _process(delta: float) -> void:
	
	#if not seeingPlayer:
		##if Head_IK.is_running():
			##Head_IK.stop()
		#
		#if velocity.length() > 0:
			#var lookdir = atan2(velocity.x, velocity.z)
			#rotation.y =  lerp_angle(rotation.y, lookdir, ROTATION_SPEED * delta)
	#else:
		var playerloc = player.playerCamera.global_position - head.global_position
		var lookdir = atan2(playerloc.x, playerloc.z)

		
		if target:
			
			#if not Head_IK.is_running():
				#Head_IK.start()
			
			# Get the direction vector from object X to object Y
			var TarDirection = (playerloc).normalized()
			
			target.position = lerp(target.position, head.global_position + TarDirection, delta *3)
			var IKlookdir = atan2(TarDirection.x,TarDirection.z)
			var IKlookdirx = atan2(-TarDirection.y, sqrt(TarDirection.x * TarDirection.x + TarDirection.z * TarDirection.z))
			
			target.rotation.y = lerp_angle(target.rotation.y, IKlookdir , delta *3)
			target.rotation.x = lerp_angle(target.rotation.x, IKlookdirx , delta *3)
			
		rotation.y =  lerp_angle(rotation.y, lookdir, delta * .3)
		

func _physics_process(delta):
	
	if not Global.incutscene and canMove:
		await get_tree().physics_frame
		var next_location = nav.get_next_path_position()
		var currentLocation = global_transform.origin
		var new_velocity = (next_location - currentLocation).normalized() * MOVE_SPEED
		nav.set_velocity(new_velocity)
	pass

func velocity_computed(safe_velocity):
	if(self.process_mode != PROCESS_MODE_DISABLED):
		if canMove:
			velocity = safe_velocity
			move_and_slide()
