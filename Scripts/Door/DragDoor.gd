extends Door

@export var pull_power = 10
@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var mouse_x = 0

var data

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
	if(door.get_parent() == get_parent()) :
			data = door
			mouse_x = 0

			player.playerCamera.locked = true


func _input(event):
	if(data):
		if(event is InputEventMouseMotion):
			if(data != null):
				mouse_x += event.relative.x
				mouse_x = clamp(mouse_x, -1, 1)
				print(mouse_x)

func Update(delta):
	if data:
		var a = data.global_transform.origin
		var b = mouse_x * grab_position.global_transform.origin
		data.set_linear_velocity((b-a) *delta* pull_power)
