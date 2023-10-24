extends Node3D

@export var pull_power = 3
@onready var _sensitivity = ProjectSettings.get_setting("player/look_sensitivity")
var mouse_x = 0

var data
var action
var active : bool = false
var camera : Camera3D
var grab_position
var player : Node

func _ready():
	player = Global._get_player()
	camera = player.get_node("Camera3D") as Camera3D
	grab_position = player.get_node("Camera3D/GrabPosition")
	action = player.get_node("Action") as PlayerAction
	action.connect("start_interaction", InteractWithDoor)
	action.connect("end_interaction", remove_object)

func remove_object():
	if(data != null):
		data = null
	active = false
	camera.locked = false

func InteractWithDoor(door:Node3D):
	if(door.get_parent() == get_parent()):
		data = door
		camera.locked = true
		mouse_x = 0
		active = true

var do : bool = true
func _input(event):
	if(active):
		if(event is InputEventMouseMotion):
			if(data != null):
				var Dir = (player.global_transform.origin - data.global_transform.origin)
				var eventDir = Dir * -event.relative.x * _sensitivity
				print(eventDir)
				data.rotate_y(eventDir.x) 
