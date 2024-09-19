extends Node

var player_Input : Inputs
var animation : AnimationTree
@export var weaponCol : Area3D
@export var BloodInstance : CPUParticles3D
@export var checkHit : bool = false

var player : Player
var beast : Beast

var inArea : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent() as Player
	player_Input = player.playerInput
	animation = player.animation
	
	player_Input.connect("KeyPressed", Attack)
	animation.connect("animation_finished", animation_finished)
	weaponCol.connect("body_entered", AxeEnter)
	weaponCol.connect("body_exited", AxeExit)

func AxeEnter(body):
	if body is Beast:
		inArea = true
		beast = body

func AxeExit(body):
	if body is Beast:
		inArea = false

func Hit():
	if inArea:
		BloodInstance.emitting = true
		
		beast.gothit = true
		beast.canMove = false
		

func Attack(key):
	if key == "INTERACT":
		animation.set("parameters/conditions/ATK",true)
		await get_tree().create_timer(0.1).timeout
		animation.set("parameters/conditions/ATK",false)


func animation_finished(anim):
	pass
