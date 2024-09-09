extends CharacterBody3D
class_name Player
signal player_jumped(height)

#movement variables
var _input : Vector2 = Vector2.ZERO
var Speed : float 
var Jump_Speed : float = 300
var canJump : bool  = true
var original_gravity = 10.9
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var running : bool = true
var inertia : float = 20

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


func InputPressed(Key : StringName):
	if("RUN" == Key):
		print("started running")
		stats.CanConsume = true
		Speed = SPRINT_SPEED
	elif("JUMP" == Key):
		Jump()
	

func InputHold(Key):
	if("RUN" == Key):
		if velocity.length() > 0.5 and stats.CanConsume:
			noise.volume = 100

func InputReleasd(Key : StringName):
	if("RUN" == Key):
		print("stopped running")
		Speed = WALK_SPEED
		noise.volume = 0

func Jump():
	if(canJump):
		if(is_on_floor() and stats.Stamina > stats.CONSUME_JUMP):
			noise.volume = 50
			emit_signal("player_jumped", Jump_Speed)
			velocity.y = Jump_Speed * get_physics_process_delta_time()

func Move(delta):
	var direction = playerCamera.transform.basis * Vector3(_input.x, 0 , _input.y).normalized() * -1
	
	#if abs(_input.x) > 0:
		#camera.rotation.z = move_toward(camera.rotation.z,  deg_to_rad(-5)* sign(_input.x), delta* 0.5)
	#else:
		#camera.rotation.z = move_toward(camera.rotation.z,  deg_to_rad(0), delta* 0.5)
	
	if(direction):
		velocity.x = direction.x * Speed * delta
		velocity.z = direction.z * Speed * delta
		
	else:
		velocity.x = lerp(velocity.x, direction.x * Speed, delta * 6.5)
		velocity.z = lerp(velocity.z, direction.z * Speed, delta * 6.5)
	
	if not is_on_floor():
		velocity.y -= _gravity * delta
	move_and_slide()

@warning_ignore("unused_parameter")
func _process(delta):
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
	
	
