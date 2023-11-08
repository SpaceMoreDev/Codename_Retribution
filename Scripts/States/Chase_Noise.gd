extends State
class_name ChaseNoise

@export var speed : float = 3
@export var enemy : CharacterBody3D
@export var area : Area3D


func _ready():
	enemy.nav.connect("navigation_finished", navigation_finished)
	area.connect("body_entered", body_entered)

func Enter():
	enemy.canMove = true
	enemy.move_speed = speed

func Exit():
	enemy.move_speed = enemy.MOVE_SPEED

func navigation_finished():
	if (get_parent() as StateMachine).current_state == self:
		Transitioned.emit(self, "Idle")
		print("transitioned to Idle")


func body_entered(body):
	enemy.nav.target_position = body.global_transform.origin