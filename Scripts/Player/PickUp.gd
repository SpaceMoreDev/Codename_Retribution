extends Node
var camera : PlayerCamera
var grab_position : Node3D
var joint : Joint3D
var staticbody : StaticBody3D

@export var pull_power = 6
@export var rotation_power = 0.05

var active : bool = false
var picked_object : Node3D

var action : PlayerAction

func _ready():
	var player : Node = Global._get_player()
	camera = player.get_node("Camera3D")
	grab_position = player.get_node("Camera3D/GrabPosition")
	joint = player.get_node("Camera3D/Joint")
	staticbody = player.get_node("Camera3D/StaticBody3D")
	action = player.get_node("Action") as PlayerAction
	action.connect("start_interaction", pull_object)
	action.connect("end_interaction", remove_object)
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if active :
		if(picked_object != null):
			var a = picked_object.global_transform.origin
			var b = grab_position.global_transform.origin
			picked_object.set_linear_velocity((b-a) * pull_power)
			
func _input(event):
	if(picked_object != null):
		if(Input.is_action_just_pressed("AIM")):
			var knockback = picked_object.global_transform.origin - Global._get_player().global_transform.origin
			picked_object.apply_central_impulse(knockback * 5)
			remove_object()
			return

		if(Input.is_action_pressed("ROTATE_OBJECT")):
			camera.locked = true
			rotate_object(event)
		elif(Input.is_action_just_released("ROTATE_OBJECT")):
			camera.locked = false

func remove_object():
	if(picked_object != null):
		picked_object = null
		joint.node_b = joint.get_path()
		active = false
		camera.locked = false

func rotate_object(event):
	if(picked_object != null):
		if(event is InputEventMouseMotion):
			staticbody.rotate_x(deg_to_rad(event.relative.y * rotation_power))
			staticbody.rotate_y(deg_to_rad(event.relative.x * rotation_power))

func pull_object(obj : Node3D):
	if(obj.get_parent() == get_parent()):
		picked_object = obj
		joint.node_b = obj.get_path()
		active = true
