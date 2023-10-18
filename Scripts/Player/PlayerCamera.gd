extends Camera3D

@onready var _player_head: Node3D = get_parent()
@onready var _player_camera: Camera3D = self

@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.0

#head bob
@export var _frequency = 3
@export var _amplitude = 0.08
var t_bob = 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
#	$AnimationPlayer.play("human|Idle")

func _unhandled_input(event):
	if(event is InputEventMouseMotion):
		_player_head.rotate_y(-event.relative.x * _sensitivity)
		_player_camera.rotate_x(-event.relative.y * _sensitivity)
		_player_camera.rotation.x = clamp(_player_camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	t_bob += delta * get_parent().velocity.length() * float(get_parent().is_on_floor())
	_player_camera.transform.origin = head_bobbing(t_bob)

	# FOV
	var velocity_clamped = clamp(get_parent().velocity.length(), 0.5, get_parent().SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	_player_camera.fov = lerp(_player_camera.fov, target_fov, delta * 8.0)



func head_bobbing(time)->Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time *_frequency) * _amplitude
	pos.x = cos(time *_frequency/2) * _amplitude
	return pos
