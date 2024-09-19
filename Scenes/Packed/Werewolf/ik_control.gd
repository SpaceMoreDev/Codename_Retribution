extends Node3D
class_name  IK_Control

@export var IK : SkeletonIK3D
@export var curve : Curve
var value : float = 1

# Called when the node enters the scene tree for the first time.
func Activate():
	if IK.is_running():
		get_tree().create_tween().tween_property(IK, "influence", 1 , .5).set_ease(Tween.EaseType.EASE_IN)

func Dectivate():
	if not IK.is_running():
		get_tree().create_tween().tween_property(IK, "influence", 0 , .5).set_ease(Tween.EaseType.EASE_OUT)
