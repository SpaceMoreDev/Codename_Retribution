extends Node3D
class_name PlayerCamera

@export var ControllerDeadzone: float = 0.5
@export var player : Player
var playerCamera : Node3D
var playerInputs : Inputs


var _sensitivity : float;

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.0
const MouseSMOOTHING = 20
const JoySMOOTHING = 10

var lookAxis : Vector2 = Vector2.ZERO
var locked : bool = false
var rotation_velocity : Vector2
var b_isController : bool = false

func _ready():
	player = Global._get_player()
	playerCamera = $Camera3D
	playerInputs = player.playerInput
	_sensitivity = playerInputs.mouse_sensitivity
	
	playerInputs.connect("MouseMotion", LookAroundMouse)
	playerInputs.connect("JoyMotion", LookAroundJoy)

func LookAroundMouse(axis : Vector2):
	b_isController = false
	if(not locked):
		lookAxis = -axis

func LookAroundJoy(axis : Vector2):
	b_isController = true
	if(not locked):
		lookAxis = -axis

func _physics_process(delta):
	
	if(not locked):	
		# FOV
		var velocity_clamped = clamp(get_parent().velocity.length(), 0.5, get_parent().SPRINT_SPEED * 2)
		var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		playerCamera.fov = lerp(playerCamera.fov, target_fov, delta * 8.0)

func _process(delta):
	if(not locked):	
		if b_isController:
			rotation_velocity = lerp(rotation_velocity, lookAxis, delta * JoySMOOTHING)
			playerCamera.rotate_x(deg_to_rad(rotation_velocity.y) )
			rotate_y(deg_to_rad(rotation_velocity.x))
		else:
			rotation_velocity = lerp(rotation_velocity, lookAxis, delta * MouseSMOOTHING)
			playerCamera.rotate_x(deg_to_rad(rotation_velocity.y) )
			rotate_y(deg_to_rad(rotation_velocity.x))
			lookAxis = Vector2.ZERO
		
		playerCamera.rotate_x(deg_to_rad(rotation_velocity.y) )
		rotate_y(deg_to_rad(rotation_velocity.x))
		playerCamera.rotation.x = clamp(playerCamera.rotation.x, deg_to_rad(-60), deg_to_rad(60))


