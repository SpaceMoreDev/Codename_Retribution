extends Node3D

@export var target : Node3D
@export var IK : SkeletonIK3D
var old_position
var rest_position = Vector3(0,1.7,0)

var futurePos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	IK.start()
	futurePos = global_position + rest_position
	old_position = target.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	futurePos = global_position + rest_position
	target.global_position = lerp(target.global_position, futurePos, delta * 1)
	
func _physics_process(delta: float) -> void:
	global_rotation = Vector3.ZERO
	
	pass
