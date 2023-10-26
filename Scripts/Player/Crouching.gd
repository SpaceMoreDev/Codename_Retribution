extends Node

class_name Crouching

@export var raycheck : RayCast3D
@export var camera : Camera3D
@export var headBob : HeadBobbing
@export var standingCollider: CollisionShape3D
@export var crouchingCollider: CollisionShape3D

const CROUCHING_AMOUNT = 0.5
const CROUCHING_SPEED = 1

const CROUCHING_FREQ = 5
const CROUCHING_AMP = 0.07

var crouchingHeight : float

var acceleration : float = 2
var active = false
var notpressing:bool
var player: Player
func _ready():
	player = get_parent()
	crouchingHeight = camera.position.y - CROUCHING_AMOUNT
	standingCollider.disabled = false
	crouchingCollider.disabled = true

@warning_ignore("unused_parameter")
func _process(delta):	
	if(Input.is_action_just_pressed("CROUCH")):
		standingCollider.disabled = true
		crouchingCollider.disabled = false
		player.Speed = CROUCHING_SPEED
		active = true
		notpressing = true
		headBob._frequency = CROUCHING_FREQ
		headBob._amplitude = CROUCHING_AMP
	elif Input.is_action_pressed("CROUCH"):
		camera.position.y = move_toward(camera.position.y, crouchingHeight, delta * acceleration)
	elif(Input.is_action_just_released("CROUCH")):
		if is_top_empty():
			standingCollider.disabled = false
			crouchingCollider.disabled = true
			player.Speed = player.WALK_SPEED
		notpressing = false
	else:
		if not notpressing and active:
			if is_top_empty():
				camera.position.y = move_toward(camera.position.y, 0.0, delta * acceleration)
				if camera.position.y == 0:
					standingCollider.disabled = false
					crouchingCollider.disabled = true
					player.Speed = player.WALK_SPEED
					active = false


					headBob._frequency = headBob.STAND_FREQ
					headBob._amplitude = headBob.STAND_AMP

func is_top_empty() -> bool:
	if raycheck.is_colliding() :
		return false
	return true
