extends Node

@export var standingCollider: CollisionShape3D
@export var crouchingCollider: CollisionShape3D
@export var camera: Camera3D
@export var headBob: HeadBobbing

const CROUCHING_AMOUNT = 0.5
var crouchingHeight : float

var acceleration : float = 7
var active = false
func _ready():
	crouchingHeight = camera.position.y - CROUCHING_AMOUNT
	standingCollider.disabled = false
	crouchingCollider.disabled = true

@warning_ignore("unused_parameter")
func _process(delta):
	if(Input.is_action_just_pressed("CROUCH")):
		standingCollider.disabled = true
		crouchingCollider.disabled = false
		headBob.crouching = true
		active = true
	elif(Input.is_action_pressed("CROUCH")):
		camera.position.y = lerp(camera.position.y, crouchingHeight, delta * acceleration)
		
	elif(Input.is_action_just_released("CROUCH")):
		standingCollider.disabled = false
		crouchingCollider.disabled = true
	else:
		if active:
			if(not is_zero_approx(camera.position.y)):
				camera.position.y = lerp(camera.position.y, 0.0, delta * acceleration)
			else:
				active = false
				headBob.crouching = false
