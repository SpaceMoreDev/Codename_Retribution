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


var locked : bool = false

func _ready():
	player = Global._get_player()
	playerCamera = $Camera3D
	playerInputs = player.playerInput
	_sensitivity = playerInputs._sensitivity
	
	playerInputs.connect("MouseMotion", LookAround)
	playerInputs.connect("JoyMotion", LookAround)

func LookAround(axis : Vector2):
	if(not locked):
		rotate_y(-axis.x * get_process_delta_time() * _sensitivity)
		playerCamera.rotate_x(-axis.y * get_process_delta_time() * _sensitivity)
		
		playerCamera.rotation.x = clamp(playerCamera.rotation.x, deg_to_rad(-60), deg_to_rad(60))

func _physics_process(delta):
	if(not locked):
		# FOV
		var velocity_clamped = clamp(get_parent().velocity.length(), 0.5, get_parent().SPRINT_SPEED * 2)
		var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		playerCamera.fov = lerp(playerCamera.fov, target_fov, delta * 8.0)
	


