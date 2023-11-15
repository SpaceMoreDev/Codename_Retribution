extends Node
class_name PickUpObject

var camera : Node3D
var cameraSc : PlayerCamera

var grab_position : Node3D
var joint : Joint3D
var staticbody : StaticBody3D

@export var snap_distance := 3

@export var pull_power = 4
@export var rotation_power = 0.05
@export var rb : RigidBody3D

var active : bool = false
var picked_object : Node3D

var action : PlayerAction

func DetectObjects(canDo : bool):
	if canDo:
		rb.contact_monitor = true
		rb.max_contacts_reported = 2
	else:
		rb.contact_monitor = false
		rb.max_contacts_reported = 0


func _ready():
	var player : Node = Global._get_player()

	camera = player.camera
	cameraSc = player.playerCamera
	action = player.playerAction

	joint = action.joint
	staticbody = action.staticbody
	grab_position = action.grab_position

	action.connect("start_interaction", pull_object)
	action.connect("end_interaction", remove_object)

	rb.connect("body_entered", touched)
	pass

@warning_ignore("unused_parameter")
func _physics_process(delta):
	if active :
		if(picked_object != null):
			var distacePlayer = (camera.global_position - picked_object.global_position).length()
			print(distacePlayer)
			if distacePlayer > 0.8:
				var a = picked_object.global_transform.origin
				var b = grab_position.global_transform.origin
				if a.distance_to(b) > snap_distance:
					remove_object()
				else:
					picked_object.set_linear_velocity((b-a) * pull_power)

			
				

			
func _input(event):

	if(picked_object != null):
		if(Input.is_action_just_pressed("AIM")):
			var knockback = picked_object.global_transform.origin - Global._get_player().global_transform.origin
			picked_object.apply_central_impulse(knockback * 5)
			DetectObjects(true)
			remove_object()
			return

		if(Input.is_action_pressed("ROTATE_OBJECT")):
			cameraSc.locked = true
			rotate_object(event)
		elif(Input.is_action_just_released("ROTATE_OBJECT")):
			cameraSc.locked = false

func touched(body):
	if get_parent().has_node("NoiseControl"):
		$"../NoiseControl".volume = 100
		await get_tree().create_timer(1).timeout
		$"../NoiseControl".volume = 0

		DetectObjects(false)
	else:
		if body is Player:
			body.stats.Health -= 10
			DetectObjects(false)

func remove_object():
	
	if(picked_object != null):
		picked_object.set_collision_mask_value(2, true)
		picked_object = null
		joint.node_b = joint.get_path()
		active = false
		if cameraSc.locked:
			cameraSc.locked = false
		

func rotate_object(event):
	if(picked_object != null):
		if(event is InputEventMouseMotion):
			staticbody.rotate_x(deg_to_rad(event.relative.y * rotation_power))
			staticbody.rotate_y(deg_to_rad(event.relative.x * rotation_power))

func pull_object(obj : Node3D):
	if(obj.get_parent() == get_parent()):
		picked_object = obj
		picked_object.set_collision_mask_value(2, false)
		joint.node_b = obj.get_path()
		active = true
