extends Node3D

class_name Fire

@export var areaTrigger : Area3D 
var time = 10


func _ready():
	areaTrigger.connect("body_entered", OnTouchFire)

func OnTouchFire(body:Node3D):
	if not body.has_node("Fire"):
		var newFire = Global.firePrefab.instantiate()
		body.add_child(newFire)
		
		await get_tree().create_timer(time).timeout
		newFire.queue_free()
