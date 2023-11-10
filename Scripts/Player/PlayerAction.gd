extends Node3D

class_name PlayerAction

signal start_interaction(collider)
signal end_interaction()

@export var raycast_length = 2
@export var handIcon : TextureRect
var ray : RayCast3D
var joint : Joint3D
var staticbody : StaticBody3D
var grab_position : Node3D


var isDoingAction = false

func _enter_tree():
	ray = $"RayCast3D"
	joint = $"Joint"
	staticbody = $"StaticBody3D"
	grab_position = $"GrabPosition"

func _ready():
	ray.target_position = Vector3(0,0,-raycast_length)
	connect("start_interaction", interact)

@warning_ignore("unused_parameter")
func _physics_process(delta):
	
	if(not isDoingAction and ray.is_colliding()):
		handIcon.visible = true
	else:
		handIcon.visible = false
	
	if(not isDoingAction and Input.is_action_just_pressed("INTERACT")):
		check_if_hit()
		isDoingAction = true
	elif(Input.is_action_just_released("INTERACT")):
		isDoingAction = false
		emit_signal("end_interaction")

func check_if_hit():
	if (ray.is_colliding()):
		var collider = ray.get_collider()
		emit_signal("start_interaction", collider)

func interact(with):
	print("interacted with %s" % with)
