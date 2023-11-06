extends Node3D

class_name Fire

@export var areaTrigger : Area3D 
var player : Player 
var time = 10
var playerin = false
var damageTimer : float

func _ready():
	player = Global._get_player()
	areaTrigger.connect("body_entered", OnTouchFire)
	areaTrigger.connect("body_exited", body_exited)
	areaTrigger.add_to_group("Fire")

func OnTouchFire(body:Node3D):
	if body is Player:
		print("player on fire")
		playerin = true
	elif not body.has_node("Fire"):
		var newFire = Global.firePrefab.instantiate()
		body.add_child(newFire)
		
		await get_tree().create_timer(time).timeout
		newFire.queue_free()
		
func _process(delta):
	if playerin:
		if damageTimer > 0 :
			damageTimer -= delta
		else:
			player.Stats.Health -= 10
			damageTimer = 1
	

func body_exited(body):
	if body is Player:
		print("player not on fire")
		playerin = false

