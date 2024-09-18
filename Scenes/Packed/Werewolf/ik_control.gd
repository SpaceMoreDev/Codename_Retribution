extends Node3D
class_name  IK_Control

@export var IK : SkeletonIK3D
var value = 1

# Called when the node enters the scene tree for the first time.
func ChangeIK(val):
	value = val
	print("assssssssss ",value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	IK.influence = lerp(IK.influence, float(value), delta * 10)
	#print(IK.influence)
