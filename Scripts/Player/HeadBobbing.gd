extends Node
class_name HeadBobbing

var player : Player
var isActive = true
@export var Anim : AnimationTree

const power = 10

func _ready():
	player = Global._get_player()
func _process(delta):
	if isActive:
		if player.velocity.length() > 0.05:
			Anim.set("parameters/Game/conditions/HeadBobing",1)
			Anim.set("parameters/Game/conditions/HeadRest",0)
			if player.isrunning:
				Anim.set("parameters/Game/conditions/Sprinting",1)
				Anim.set("parameters/Game/conditions/HeadBobing",0)
			else:
				Anim.set("parameters/Game/conditions/Sprinting",0)
				Anim.set("parameters/Game/conditions/HeadBobing",1)
			
		else:
			Anim.set("parameters/Game/conditions/HeadBobing",0)
			Anim.set("parameters/Game/conditions/HeadRest",1)
			Anim.set("parameters/Game/conditions/Sprinting",0)
