extends Node3D
class_name PlayerCamera

@export var ControllerDeadzone: float = 0.5
@export var _player_head: Node3D
@export var _player_camera: Camera3D

@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.0


var locked : bool = false

func _unhandled_input(event):
	if(not locked):
		if(event is InputEventMouseMotion):
			_player_head.rotate_y(-event.relative.x * _sensitivity)
			_player_camera.rotate_x(-event.relative.y * _sensitivity)
			_player_camera.rotation.x = clamp(_player_camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		elif event is InputEventJoypadMotion:
			var controllerangle = Vector2.ZERO
			
			var xAxisRL = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X) * _sensitivity
			var yAxisUD = Input.get_joy_axis(0 ,JOY_AXIS_RIGHT_Y) * _sensitivity
			
			controllerangle = Vector2(xAxisRL, yAxisUD)
			if abs(controllerangle.length()) > ControllerDeadzone:
				_player_head.rotate_y(-controllerangle.x)
				_player_camera.rotate_x(-controllerangle.y)
				_player_camera.rotation.x = clamp(_player_camera.rotation.x, deg_to_rad(-60), deg_to_rad(60))
				print(controllerangle)
	

func _physics_process(delta):
	if(not locked):
		# FOV
		var velocity_clamped = clamp(get_parent().velocity.length(), 0.5, get_parent().SPRINT_SPEED * 2)
		var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		_player_camera.fov = lerp(_player_camera.fov, target_fov, delta * 8.0)
	


