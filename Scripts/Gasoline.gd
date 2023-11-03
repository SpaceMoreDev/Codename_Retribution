extends Area3D

var active = false
func _ready():
	connect("area_entered", Body_Entered)

@warning_ignore("unused_parameter")
func Body_Entered(body:Area3D):
	if not active:
		active = true
		var newFire =  Global.firePrefab.instantiate()
		add_child(newFire)
		newFire.position.y += 0.2
		await get_tree().create_timer(20).timeout
		get_parent().queue_free()
