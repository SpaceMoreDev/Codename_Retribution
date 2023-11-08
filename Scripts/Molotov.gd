extends Item
class_name Molotov

var rigidBody : RigidBody3D
var tobreak : bool = false
var gasNodes : Node3D
var player 
var dir : Vector3 = Vector3(1,0,1) 
var force : float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	rigidBody = $molotov
	gasNodes = get_tree().root.get_node("/root/World/Enviroment/GasolineSpots")
	player = Global._get_player()
	rigidBody.connect("body_entered", touched)

func Use(throw_power : float):
	force = throw_power
	tobreak = true
	rigidBody.contact_monitor = true
	rigidBody.max_contacts_reported = 1
	rigidBody.set_collision_mask_value(2, false)
	rigidBody.set_collision_layer_value(3, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func touched(body):
	if tobreak:
		print("touched")
		var spot : Node3D = Global.firePrefab.instantiate()
		gasNodes.add_child(spot)
		spot.global_position = rigidBody.global_position
		
		queue_free()

func Get_type():
	return "Molotov"
	
@warning_ignore("unused_parameter")
func _physics_process(delta):
	if tobreak:
		rigidBody.apply_impulse(player.basis * player.camera.basis * Vector3(0, 0, -1) * force * delta)
