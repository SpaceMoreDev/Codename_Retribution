extends Node

class_name Crouching

@export var raycheck : RayCast3D
@export var camera : Camera3D
@export var headBob : HeadBobbing
@export var standingCollider: CollisionShape3D
@export var crouchingCollider: CollisionShape3D

var CROUCHING_AMOUNT = 0.55
var CROUCHING_SPEED = 50

const CROUCHING_FREQ = 5
const CROUCHING_AMP = 0.05

var crouchingHeight : float

var acceleration : float = 0.6
var active = false
var notpressing:bool
var player: Player
var crouchTween : Tween
var crouchToggle : bool = false

func _ready():
	player = get_parent()
	crouchingHeight = camera.position.y - CROUCHING_AMOUNT
	standingCollider.disabled = false
	crouchingCollider.disabled = true


func crouching():
	crouchingCollider.disabled = false
	standingCollider.disabled = true
	active = true
	player.Speed = CROUCHING_SPEED
	player.noise.volume = 0
func stop_crouching():
	if is_top_empty():
		standingCollider.disabled = false
		crouchingCollider.disabled = true
		player.Speed =player.WALK_SPEED
		active = false
func Toggle():
	crouchToggle = !crouchToggle
	if crouchToggle:
		crouchTween = get_tree().create_tween()
		crouchTween.tween_property(camera,"position:y",crouchingHeight,0.1)
		crouchTween.finished.connect(crouching)
	else:
		crouchTween = get_tree().create_tween()
		crouchTween.tween_property(camera,"position:y",0.0, 0.1)
		crouchTween.finished.connect(stop_crouching)
@warning_ignore("unused_parameter")
func _process(delta):
	if(Input.is_action_just_pressed("CROUCH")) and is_top_empty():
		Toggle()


func is_top_empty() -> bool:
	if raycheck.is_colliding() :
		return false
	return true
