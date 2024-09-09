extends Node3D
class_name PlayerCamera

@export var ControllerDeadzone: float = 0.5
@export var player : Player
var playerCamera : Node3D
var playerInputs : Inputs


#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.0
const SMOOTHING = 20

var lookAxis : Vector2 = Vector2.ZERO
var locked : bool = false
var rotation_velocity : Vector2
var b_isController : bool = false

func _ready():
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	player = Global._get_player()
	playerCamera = $Camera3D
	playerInputs = player.playerInput
	
	playerInputs.connect("MouseMotion", LookAround)
	playerInputs.connect("JoyMotion", LookAround)

func LookAround(axis : Vector2):
	if(not locked):
		lookAxis = -axis


func _process(delta):
	if(not locked):
		rotation_velocity = lerp(rotation_velocity, lookAxis, delta * SMOOTHING)
		playerCamera.rotate_x(deg_to_rad(rotation_velocity.y) )
		rotate_y(deg_to_rad(rotation_velocity.x))
		playerCamera.rotation.x = clamp(playerCamera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		lookAxis = Vector2.ZERO
		
		# FOV
		var velocity_clamped = clamp(get_parent().velocity.length(), 0.5, get_parent().SPRINT_SPEED * 2)
		var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		playerCamera.fov = lerp(playerCamera.fov, target_fov, delta * 8.0)
