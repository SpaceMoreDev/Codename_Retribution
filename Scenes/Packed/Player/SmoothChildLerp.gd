extends Node3D

@export var follow_target : Node3D
@export var speed = 50

## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#global_position = follow_target.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = follow_target.position
	rotation = follow_target.rotation
	pass
