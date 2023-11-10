extends Node3D

class_name DoorKey

@export var door : Door
@export var objective : Objective


func _ready():
	door.key = self as DoorKey
	# door.Lock(true)
