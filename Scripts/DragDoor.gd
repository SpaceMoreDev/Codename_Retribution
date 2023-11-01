extends Node3D

@export var pull_power = 3
@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var mouse_x = 0

var data
var action
var active : bool = false
var camera : Camera3D
var cameraSc : PlayerCamera
var grab_position
var player : Node

func _ready():
	player = Global._get_player()
	camera = player.get_node("Head/Camera3D") as Camera3D
	cameraSc = player.get_node("Head")
	action = camera.get_node("Action") as PlayerAction
	grab_position = action.get_node("GrabPosition")
	action.connect("start_interaction", InteractWithDoor)
	action.connect("end_interaction", remove_object)

func remove_object():
	if(data != null):
		data = null
	active = false
	cameraSc.locked = false

func InteractWithDoor(door:Node3D):
	if(door.get_parent() == get_parent()):
		if not (get_parent() as Door).locked :
			data = door
			mouse_x = 0
			cameraSc.locked = true
			active = true
		else:
			print("Door locked!")

func _input(event):
	if(active):
		if(event is InputEventMouseMotion):
			if(data != null):
				var Dir = (player.global_transform.origin - data.global_transform.origin)
				var eventDir = Dir * -event.relative.x * _sensitivity
				
				data.rotate_y(eventDir.x) 
				data.rotation.y = clamp(data.rotation.y, deg_to_rad(-110), deg_to_rad(0))
				if data.rotation.y < 0:
					(get_parent() as Door).opened = true
					print("opened!")

					if (get_parent() as Door).hasquest:
						Global.questList.CompleteQuest((get_parent() as Door).questID)
						(get_parent() as Door).hasquest = false
				else:
					(get_parent() as Door).opened = false
					print("closed!")
