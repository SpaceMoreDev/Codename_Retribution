extends Area3D

func _ready():
	connect("body_entered", restart)

func restart(body):
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()