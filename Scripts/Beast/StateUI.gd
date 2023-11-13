extends Label

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	text = "Enemy State: %s"%Global.enemyState
