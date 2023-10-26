extends Node3D
class_name PlayerCamera

@export var _player_head: Node3D
@export var _player_camera: Camera3D

@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.0


var locked : bool = false

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if(not locked):
		if(event is InputEventMouseMotion):
			_player_head.rotate_y(-event.relative.x * _sensitivity)
			_player_camera.rotate_x(-event.relative.y * _sensitivity)
			_player_camera.rotation.x = clamp(_player_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
	

func _physics_process(delta):
	if(not locked):
		# FOV
		var velocity_clamped = clamp(get_parent().velocity.length(), 0.5, get_parent().SPRINT_SPEED * 2)
		var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
		_player_camera.fov = lerp(_player_camera.fov, target_fov, delta * 8.0)
	


