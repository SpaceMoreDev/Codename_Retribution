extends Mission

@export var trigger : Area3D

func _ready():
	trigger.connect("body_entered", triggered)

func triggered(body):
	if body is Player:
		MissionCompleted.emit()
		print("mission Completed")
		queue_free()
