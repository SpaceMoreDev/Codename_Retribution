extends Door

@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var mouse_x : float = 0.0

var data
var dead_zone : float = 1

var pull_power = 150

var action
var player
var grab_position

func _ready():
	player = Global._get_player()
	action = player.playerAction
	grab_position = action.grab_position

	action.connect("start_interaction", InteractWithDoor)
	action.connect("end_interaction", remove_object)

func remove_object():
	if(data != null):
		data = null
	player.playerCamera.locked = false

func InteractWithDoor(door:Node3D):
	if door == $body :
		player.playerCamera.locked = true
		if not is_locked:
			data = door
			mouse_x = 0.0
		else:
			print("Locked")
			

func _input(event):
	if(data != null):
		if(event is InputEventMouseMotion):		
			mouse_x = -event.relative.x * _sensitivity
			# mouse_x = clamp(mouse_x, -1, 1)
		else:
			mouse_x = 0.0



func Update(delta):
	if(data != null and not is_locked):
		if abs(mouse_x) > 0:
			var cam = player.playerCamera.global_position # location of player
			
			var camtodoor = data.global_position - cam
			var doortocam = cam - data.global_position

			# DebugDraw3D.draw_ray(cam, camtodoor, camtodoor.length() , Color(1,0, 0))

			var raydir = sign(camtodoor.z) # direction to player whether looking or not
			var dirPoint = (data.global_position + (data.get_node("handle").global_transform.basis * Vector3.RIGHT *(raydir *mouse_x)))
			print(raydir)

			
			# DebugDraw3D.draw_box(dirPoint, Vector3(.1,.1,.1), Color(1, 1, 0), true)
			var doordir = ( dirPoint - data.global_position ) 
			data.set_linear_velocity(doordir * pull_power * delta)
			return

	# $body.linear_velocity =$body.linear_velocity.move_toward(Vector3.ZERO, delta *5)
	# print($body.linear_velocity)
			
		


