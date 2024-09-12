extends Area3D
class_name  DoorIK

@export var IK_target : Node3D
var can_open_door : bool = false

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exit)

func _on_body_entered(body: Node3D) -> void:
	can_open_door = true
	

func _on_body_exit(body:Node3D)->void:
	can_open_door = false
