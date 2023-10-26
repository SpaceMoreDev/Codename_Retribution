extends Node
class_name HeadBobbing
@export var head : Node3D
@export var _frequency = 4
@export var _amplitude = 0.05
@export var crouching : Crouching

const STAND_FREQ = 4
const STAND_AMP = 0.05

var acceleration : float = 5
var t_bob = 0.0
var crouchVector : Vector3

func _ready():
	crouchVector = Vector3(0.0, crouching.crouchingHeight, 0.0)

func _physics_process(delta):
	if(not head.locked):
		t_bob += delta * get_parent().velocity.length() * float(get_parent().is_on_floor())
		var headbobbing =  head_bobbing(t_bob)
		head.position = headbobbing

func head_bobbing(time)->Vector3:
	var pos = Vector3.ZERO	
	pos.y = sin(time *_frequency) * _amplitude
	pos.x = cos(time *_frequency/1.5) * _amplitude
	return pos
