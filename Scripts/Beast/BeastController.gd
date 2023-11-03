extends CharacterBody3D
class_name Beast

@onready var navigation : NavigationAgent3D = $NavigationAgent3D
@onready var player : Player = Global._get_player()
@export var speed : float = 100
@export var turn_speed : float = 4.0
@export var faceDir : Node3D
@onready var detection : Detection = $Detection

var timeDelta : float
var active
var rotationActive = true

@warning_ignore("unused_parameter") 

func _ready():
	add_to_group("Beast")
	navigation.connect("velocity_computed", velocity_computed)
	navigation.connect("target_reached", Target_Reached)

func _physics_process(delta):
	timeDelta = delta
	if active:
		Set_Target_Location(player.global_transform.origin)

	await get_tree().process_frame	
	var next_location = navigation.get_next_path_position()
	var currentLocation = global_transform.origin
	var new_velocity = (next_location - currentLocation).normalized() * delta * speed
	navigation.set_velocity(new_velocity)
	
	if rotationActive:
		faceDir.look_at(transform.origin + velocity, Vector3.UP)
		rotate_y(deg_to_rad(faceDir.rotation.y * turn_speed))

	
func Target_Reached():
	rotationActive = false

func Set_Target_Location(targetLocation):
	navigation.target_position = targetLocation
	rotationActive = true
	

func velocity_computed(safe_velocity):
	if(self.process_mode != PROCESS_MODE_DISABLED) :
		velocity = velocity.move_toward(safe_velocity, .25)
		if not detection.CheckFire():
			move_and_slide()
