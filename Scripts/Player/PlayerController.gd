extends CharacterBody3D
class_name Player


signal player_jumped(height)

#movement variables
var _input : Vector2 = Vector2.ZERO
var Speed : float = 5.0
var Jump_Speed : float = 3.0
var canJump : bool  = true
var original_gravity = 10.9
var _gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var running : bool = true
var inertia : float = 20

#components
var playerAction : PlayerAction
var camera : Camera3D
var stats : PlayerStats
var noise : NoiseControl
var inventory : Inventory

#constants
const WALK_SPEED = 2
const SPRINT_SPEED = 3

func _enter_tree():
	add_to_group("Player")
	playerAction = $"Head/Camera3D/Action" as PlayerAction 
	camera = $"Head/Camera3D" as Camera3D 
	stats = $"Stats"
	noise = $"NoiseControl"
	inventory = $Inventory
	Speed = WALK_SPEED


func Jump():
	if(canJump and Input.is_action_just_pressed("JUMP")):
		if(is_on_floor() and stats.Stamina > stats.CONSUME_JUMP):
			noise.volume = 100
			noise.volume = 0
			emit_signal("player_jumped", Jump_Speed)
			velocity.y = Jump_Speed
			

func Move(delta):
	var direction = transform.basis * Vector3(_input.x, 0 , _input.y).normalized()
	
	if(is_on_floor()):
		Jump()
		if(direction):
			velocity.x = direction.x * Speed
			velocity.z = direction.z * Speed
		else:
			velocity.x = lerp(velocity.x, direction.x * Speed, delta * 6.5)
			velocity.z = lerp(velocity.z, direction.z * Speed, delta * 6.5)
	else:
		velocity.x = lerp(velocity.x, direction.x * Speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * Speed, delta * 3.0)
		velocity.y -= _gravity * delta
	move_and_slide()

@warning_ignore("unused_parameter")
func _process(delta):
	_input = Input.get_vector("LEFT","RIGHT","UP","DOWN")
	if _input.length()>0:
		noise.volume = 50
		print(noise.volume)
	if(Input.is_action_just_pressed("RUN")):
		stats.CanConsume = true
		Speed = SPRINT_SPEED
	elif(Input.is_action_pressed("RUN")):
		noise.volume = 100
	elif(Input.is_action_just_released("RUN")):
		Speed = WALK_SPEED
		noise.volume = 0

func _physics_process(delta):
	Move(delta)
	
	
