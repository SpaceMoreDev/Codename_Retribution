extends Node3D

@export var fireParticles : Fire
@export var ignitionArea : Area3D

var active : bool = false

func _ready():
	ignitionArea.connect("body_entered", Body_Entered)

func Body_Entered(body:Node3D):
	print(body)
	if not active and not fireParticles.isactive:
		fireParticles.Fire_State(true)
		await get_tree().create_timer(5).timeout
		queue_free()
