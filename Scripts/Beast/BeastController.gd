extends CharacterBody3D
class_name Beast

@onready var navigation : NavigationAgent3D = $NavigationAgent3D
@onready var player : Player = Global._get_player()
@export var speed : float = 100

@warning_ignore("unused_parameter") 

func _ready():
	add_to_group("Beast")
	navigation.connect("velocity_computed", velocity_computed)

func _physics_process(delta):
	
	Set_Target_Location(player.global_transform.origin)
	look_at(player.global_position, Vector3.UP)
	await get_tree().process_frame	
	var next_location = navigation.get_next_path_position()
	var currentLocation = global_transform.origin
	var new_velocity = (next_location - currentLocation).normalized() *delta * speed
	navigation.set_velocity(new_velocity)

	
func Set_Target_Location(targetLocation):
	navigation.target_position = targetLocation
	

func velocity_computed(safe_velocity):
	if(self.process_mode != PROCESS_MODE_DISABLED) :
		velocity = velocity.move_toward(safe_velocity, .25)
		move_and_slide()
