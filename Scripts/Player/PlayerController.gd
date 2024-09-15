extends CharacterBody3D
class_name Player
signal player_jumped(height)

var active = false

#movement variables
var _input : Vector2 = Vector2.ZERO
var Speed : float 
var Jump_Speed : float = 300
var canJump : bool  = true
var original_gravity = 10.9
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var isrunning : bool = false
var inertia : float = 20
@export var animation : AnimationTree
@export var R_Arm_IK : SkeletonIK3D
@export var L_Arm_IK : SkeletonIK3D

#components
var playerAction : PlayerAction
var playerInput : Inputs
var camera : Camera3D
var playerCamera : PlayerCamera
var stats : PlayerStats
var noise : NoiseControl
var inventory : Inventory
var crouching : Crouching

#constants
var WALK_SPEED = 200
var SPRINT_SPEED = WALK_SPEED*2

func _enter_tree():
	add_to_group("Player")
	playerInput = $"Inputs" as Inputs 
	playerAction = $"Head/Camera3D/Action" as PlayerAction 
	camera = $"Head/Camera3D" as Camera3D 
	stats = $"Stats"
	playerCamera = $"Head"
	noise = $"NoiseControl"
	inventory = $Inventory
	crouching = $Crouch
	Speed = WALK_SPEED

func _ready():
	playerInput.connect("KeyPressed", InputPressed)
	playerInput.connect("KeyReleased", InputReleasd)
	playerInput.connect("KeyHold", InputHold)

func start_R_IK(node : Node3D):
	R_Arm_IK.target_node = node.get_path()
	R_Arm_IK.active = true
	R_Arm_IK.start()
	print("IK started")
	
	
func end_R_IK():
	print("IK ended")
	R_Arm_IK.stop()
	R_Arm_IK.active = false

func start_L_IK(node : Node3D):
	L_Arm_IK.target_node = node.get_path()
	L_Arm_IK.active = true
	L_Arm_IK.start()
	print("IK started")
	
	
func end_L_IK():
	print("IK ended")
	L_Arm_IK.stop()
	L_Arm_IK.active = false


func InputPressed(Key : StringName):
	if("RUN" == Key):
		isrunning = true
		stats.CanConsume = true
		Speed = SPRINT_SPEED
	elif("JUMP" == Key):
		Jump()
	

func InputHold(Key):
	if("RUN" == Key):
		if velocity.length() > 0.5 and stats.CanConsume:
			animation.set("parameters/conditions/isIdle", false)
			animation.set("parameters/conditions/isRunning", true)
			print("running")
			noise.volume = 100

func InputReleasd(Key : StringName):
	if("RUN" == Key):
		isrunning = false
		animation.set("parameters/conditions/isIdle", true)
		animation.set("parameters/conditions/isRunning", false)
		Speed = WALK_SPEED
		noise.volume = 0

func Jump():
	if(canJump):
		if(is_on_floor() and stats.Stamina > stats.CONSUME_JUMP):
			noise.volume = 50
			emit_signal("player_jumped", Jump_Speed)
			velocity.y = Jump_Speed * get_physics_process_delta_time()

var _auto_direction = Vector3.ZERO
func Move(delta):
	var direction = playerCamera.transform.basis * Vector3(_input.x, 0 , _input.y).normalized()
	
	if(direction or _auto_direction): #moving
		if direction:
			velocity.x = direction.x * Speed * delta
			velocity.z = direction.z * Speed * delta
		else:
			velocity.x = _auto_direction.x * Speed * delta
			velocity.z = _auto_direction.z * Speed * delta
	else:
		
		velocity.x = lerp(velocity.x, direction.x * Speed, pow(6.5,delta * 6.5))
		velocity.z = lerp(velocity.z, direction.z * Speed, pow(6.5,delta * 6.5))
	
	if not is_on_floor():
		velocity.y -= _gravity * delta
	move_and_slide()

@warning_ignore("unused_parameter")
func _process(delta):
	if active and  not Global.incutscene:
		_input = Input.get_vector("LEFT","RIGHT","UP","DOWN")
		if is_on_floor():
			if velocity.length() > 0.5:
				if crouching.active:
					noise.volume = 0
				else:
					noise.volume = 50
			else:
				noise.volume = 0
			#if(Input.is_action_just_pressed("JUMP")):
				#Jump()
		Move(delta)
	
	
