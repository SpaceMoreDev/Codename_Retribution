extends Door

@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var Input_x : float = 0.0
var data
var dead_zone : float = 1
var pull_power = 150
var action
var player : Player
var grab_position

var inputs

func _ready():
	player = Global._get_player()
	action = player.playerAction
	grab_position = action.grab_position

	action.connect("start_interaction", InteractWithDoor)
	action.connect("end_interaction", remove_object)
	
	player.playerInput.connect("MouseMotion", DragInput)
	player.playerInput.connect("JoyMotion", DragInput)

func remove_object():
	if(data != null):
		data = null
	player.playerCamera.locked = false

func InteractWithDoor(door:Node3D):
	if door == $body :
		player.playerCamera.locked = true
		if not is_locked:
			data = door
			
			Input_x = 0.0
		else:
			print("Door is locked")
			

#func _input(event):
	#if(data != null):
		#if(event is InputEventMouseMotion):		
			#Input_x = -event.relative.x * _sensitivity
			## mouse_x = clamp(mouse_x, -1, 1)
		#else:
			#Input_x = 0.0

func DragInput(axis : Vector2):
	if(data != null):
		Input_x = -axis.x

func Update(delta):
	if(data != null and not is_locked):
		print(Input_x)
		if abs(Input_x) > 0:
			
			var handleBasis = data.get_node("handle").global_transform.basis
			var doorRot = (handleBasis).get_rotation_quaternion()
			var playerBasis = player.playerCamera.global_transform.basis
			var playerRot = (playerBasis).get_rotation_quaternion().inverse()
			var newBasis = Basis(doorRot * playerRot)
			
			var dirPoint = (data.global_position) + (newBasis * Vector3.LEFT *( Input_x))
			#DebugDraw3D.draw_ray(data.get_node("handle").global_position, dirPoint, dirPoint.length() , Color(1,0, 0))
			
			# DebugDraw3D.draw_box(dirPoint, Vector3(.1,.1,.1), Color(1, 1, 0), true)
			var doordir = ( dirPoint - data.global_position ) 
			data.set_linear_velocity(doordir * pull_power * delta)
			return

	# $body.linear_velocity =$body.linear_velocity.move_toward(Vector3.ZERO, delta *5)
	# print($body.linear_velocity)
			
		


