extends Node

const CAMERADISTANCE = 0.7

@export var leftRay:RayCast3D
@export var rightRay:RayCast3D

@export var horizontalDistance : float
@export var leanAngle : float = 0.5

@export var camera : Camera3D

var speed : float = 10;
var originalPos = Vector3.ZERO
var target
var active = false

func _ready():
	originalPos = camera.position.x
	horizontalDistance =  originalPos + CAMERADISTANCE

	target = camera.rotation.z * leanAngle

@warning_ignore("unused_parameter")
func _process(delta):
	
	if(Input.is_action_pressed("LEAN_LEFT")):
		check_if_hit_Left()
		camera.locked = true
		camera.position.x = lerp(camera.position.x, -horizontalDistance, delta *speed)
		camera.rotation.z = lerp(camera.rotation.z, leanAngle, delta *speed)
		active = true
	elif(Input.is_action_pressed("LEAN_RIGHT")):
		check_if_hit_Right()
		camera.locked = true
		camera.position.x = lerp(camera.position.x, horizontalDistance, delta *speed)
		camera.rotation.z = lerp(camera.rotation.z, -leanAngle, delta *speed)
		active = true
	else:
		if(camera.locked and active):
			camera.locked = false
			active = false


func check_if_hit_Left():
	if (leftRay.is_colliding()):
		var origin = leftRay.global_transform.origin
		var collision_point = leftRay.get_collision_point()
		var distance = origin.distance_to(collision_point)
		horizontalDistance = distance
	else:
		horizontalDistance =  originalPos + CAMERADISTANCE


func check_if_hit_Right():
	if (rightRay.is_colliding()):
		var origin = rightRay.global_transform.origin
		var collision_point = rightRay.get_collision_point()
		var distance = origin.distance_to(collision_point)
		horizontalDistance = distance
	else:
		horizontalDistance =  originalPos + CAMERADISTANCE
