extends Node
var camera : Node3D
var cameraSc : PlayerCamera
var grab_position : Node3D
var joint : Joint3D
var staticbody : StaticBody3D

@export var pull_power = 10
@export var rotation_power = 0.05
@export var rb : RigidBody3D

var active : bool = false
var picked_object : Node3D

var action : PlayerAction

var noiseStarted = false
func _ready():
	var player : Node = Global._get_player()
	camera = player.get_node("Head/Camera3D")
	cameraSc = player.get_node("Head")
	action = camera.get_node("Action") as PlayerAction
	joint = action.get_node("Joint")
	staticbody = action.get_node("StaticBody3D")
	grab_position = action.get_node("GrabPosition")
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
	if noiseStarted:
		$"../NoiseControl".volume = 100

	if(picked_object != null):
		if(Input.is_action_just_pressed("AIM")):
			var knockback = picked_object.global_transform.origin - Global._get_player().global_transform.origin
			picked_object.apply_central_impulse(knockback * 5)
			noiseStarted = true
			remove_object()
			return

		if(Input.is_action_pressed("ROTATE_OBJECT")):
			cameraSc.locked = true
			rotate_object(event)
		elif(Input.is_action_just_released("ROTATE_OBJECT")):
			cameraSc.locked = false

func remove_object():
	if(picked_object != null):
		picked_object = null
		joint.node_b = joint.get_path()
		active = false
		
		cameraSc.locked = false
		if noiseStarted:
			await get_tree().create_timer(2).timeout
			$"../NoiseControl".volume = 0
			noiseStarted = false
		

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
