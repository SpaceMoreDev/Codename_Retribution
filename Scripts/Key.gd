extends Node3D

class_name DoorKey

@export var doors : Array[Door]


func _ready():
	for i in doors:
		i.is_locked = true

	Global._get_player().playerAction.connect("start_interaction", GotKey)

func GotKey(obj):
	if(obj.get_parent() == self):
		for i in doors:
			i.is_locked = false
		Global._get_player().playerAction.disconnect("start_interaction", GotKey)
		obj.queue_free()
